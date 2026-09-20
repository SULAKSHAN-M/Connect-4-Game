// providers/game_provider.dart
// Central ChangeNotifier that owns the runtime game state, drives the AI,
// manages timers, and calls StatsService on game-over events.

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../ai/easy_ai.dart';
import '../ai/medium_ai.dart';
import '../ai/hard_ai.dart';
import '../logic/game_logic.dart' as gl;
import '../models/cell_state.dart';
import '../models/difficulty.dart';
import '../models/game_move.dart';
import '../models/game_result.dart';
import '../models/game_stats.dart';
import '../services/stats_service.dart';

const int kTurnSeconds   = 40;
const int kPlayerMinutes = 4;

enum TurnState { idle, humanTurn, aiThinking, gameOver }

class GameProvider extends ChangeNotifier {
  List<List<CellState>> _board       = gl.emptyBoard();
  final List<GameMove>  _moveHistory = [];
  List<List<int>>       _winCells    = [];

  GameResult   _result        = GameResult.ongoing;
  TurnState    _turnState     = TurnState.idle;
  CellState    _currentPlayer = CellState.human;
  bool         _showingStart  = false;
  int          _aiTurnIndex   = 0;

  Difficulty _difficulty = Difficulty.easy;
  String     _firstPref  = 'random';

  GameStats _stats = const GameStats();

  int    _turnSecsLeft   = kTurnSeconds;
  int    _playerSecsLeft = kPlayerMinutes * 60;
  Timer? _timer;

  List<List<CellState>> get board          => _board;
  List<List<int>>       get winCells       => _winCells;
  GameResult            get result         => _result;
  TurnState             get turnState      => _turnState;
  CellState             get currentPlayer  => _currentPlayer;
  bool                  get showingStart   => _showingStart;
  Difficulty            get difficulty     => _difficulty;
  String                get firstPref      => _firstPref;
  GameStats             get stats          => _stats;
  int                   get turnSecsLeft   => _turnSecsLeft;
  int                   get playerSecsLeft => _playerSecsLeft;
  List<GameMove>        get moveHistory    => List.unmodifiable(_moveHistory);

  bool get canUndo =>
      _moveHistory.length >= 2 &&
      _result == GameResult.ongoing &&
      _turnState == TurnState.humanTurn;

  Future<void> init() async {
    _stats      = await StatsService.loadStats();
    _difficulty = await StatsService.loadDifficulty();
    notifyListeners();
  }

  Future<void> setDifficulty(Difficulty d) async {
    _difficulty = d;
    await StatsService.saveDifficulty(d);
    notifyListeners();
  }

  void setFirstPref(String v) {
    _firstPref = v;
    notifyListeners();
  }

  void startGame() {
    _cancelTimer();
    _board       = gl.emptyBoard();
    _moveHistory.clear();
    _winCells    = [];
    _result      = GameResult.ongoing;
    _aiTurnIndex = 0;
    _turnSecsLeft   = kTurnSeconds;
    _playerSecsLeft = kPlayerMinutes * 60;

    CellState first;
    switch (_firstPref) {
      case 'human':
        first = CellState.human;
        break;
      case 'ai':
        first = CellState.ai;
        break;
      default:
        first = Random().nextBool() ? CellState.human : CellState.ai;
    }
    _currentPlayer = first;
    _showingStart  = true;
    _turnState     = TurnState.idle;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1800), () {
      _showingStart = false;
      if (_currentPlayer == CellState.ai) {
        _scheduleAi();
      } else {
        _turnState = TurnState.humanTurn;
        _startTimer();
      }
      notifyListeners();
    });
  }

  void humanMove(int column) {
    if (_turnState != TurnState.humanTurn) {
      return;
    }
    if (_result != GameResult.ongoing) {
      return;
    }
    if (!gl.isValidMove(_board, column)) return;
    _cancelTimer();
    _commitMove(column, CellState.human);
    _afterMove();
  }

  void _commitMove(int column, CellState player) {
    final row = gl.getAvailableRow(_board, column);
    if (row == -1) {
      return;
    }
    _board[row][column] = player;
    _moveHistory.add(GameMove(column: column, row: row, player: player));
  }

  void _afterMove() {
    _result = gl.evaluateResult(_board);

    if (_result != GameResult.ongoing) {
      if (_result == GameResult.humanWin) {
        _winCells = gl.checkWinner(_board, CellState.human) ?? [];
      }
      if (_result == GameResult.aiWin) {
        _winCells = gl.checkWinner(_board, CellState.ai) ?? [];
      }
      _turnState = TurnState.gameOver;
      _onGameOver(_result);
      notifyListeners();
      return;
    }

    _currentPlayer =
        _currentPlayer == CellState.human ? CellState.ai : CellState.human;

    if (_currentPlayer == CellState.ai) {
      _scheduleAi();
    } else {
      _turnSecsLeft = kTurnSeconds;
      _turnState    = TurnState.humanTurn;
      _startTimer();
    }
    notifyListeners();
  }

  void _scheduleAi() {
    _turnState = TurnState.aiThinking;
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 650), _executeAi);
  }

  void _executeAi() {
    if (_result != GameResult.ongoing) {
      return;
    }

    int col;
    switch (_difficulty) {
      case Difficulty.easy:
        col = EasyAI.getMove(_board);
        break;
      case Difficulty.medium:
        col = MediumAI.getMove(_board, _aiTurnIndex);
        break;
      case Difficulty.hard:
        col = HardAI.getMove(_board);
        break;
    }
    _aiTurnIndex++;

    if (col == -1) {
      return;
    }
    _commitMove(col, CellState.ai);
    _afterMove();
  }

  /// Removes both the AI's last move and the human's last move (one full turn).
  void undoMove() {
    if (!canUndo) {
      return;
    }
    _cancelTimer();

    // Use the library alias gl.undoMove to avoid collision with this method name
    for (int i = 0; i < 2; i++) {
      final move = _moveHistory.removeLast();
      _board = gl.undoMove(_board, move);
    }

    _result        = GameResult.ongoing;
    _winCells      = [];
    _currentPlayer = CellState.human;
    _turnState     = TurnState.humanTurn;
    _turnSecsLeft  = kTurnSeconds;
    if (_aiTurnIndex > 0) { _aiTurnIndex--; }
    notifyListeners();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_turnState != TurnState.humanTurn) {
        _cancelTimer();
        return;
      }
      if (_turnSecsLeft > 0) { _turnSecsLeft--; }
      if (_playerSecsLeft > 0) { _playerSecsLeft--; }
      notifyListeners();
      if (_turnSecsLeft <= 0 || _playerSecsLeft <= 0) {
        _cancelTimer();
        _autoRandomMove();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _autoRandomMove() {
    final col = EasyAI.getMove(_board);
    if (col != -1 && _turnState == TurnState.humanTurn) {
      humanMove(col);
    }
  }

  Future<void> _onGameOver(GameResult r) async {
    _cancelTimer();
    switch (r) {
      case GameResult.humanWin:
        _stats = await StatsService.recordWin(_stats);
        break;
      case GameResult.aiWin:
        _stats = await StatsService.recordLoss(_stats);
        break;
      case GameResult.draw:
        _stats = await StatsService.recordDraw(_stats);
        break;
      default:
        break;
    }
    notifyListeners();
  }

  Future<void> resetStats() async {
    _stats = await StatsService.resetStats();
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
