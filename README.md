# Connect 4 — Flutter Mobile App

**CSP2108 Introduction to Mobile Application Development · Assignment**

A fully functional Connect 4 game where a human player (red) competes against a rules-based AI opponent (yellow). Built with Flutter & Dart using clean architecture, Provider state management, and shared_preferences persistence.

---

## Features

| Feature | Detail |
|---|---|
| 7 × 6 board | Discs fall to the lowest available row |
| Human vs AI | Player = Red · AI = Yellow |
| 3 difficulty modes | Easy / Medium / Hard |
| Win detection | Horizontal, vertical, diagonal, anti-diagonal |
| Draw detection | Full board with no winner |
| Persistent stats | Wins / losses / draws saved across sessions |
| Undo | Removes both the player's and AI's last move |
| Turn timer | 40 s per turn · 4 min total player clock |
| 6 screens | Splash · Home · Game · Settings · Statistics · About |
| Light & Dark theme | Material 3 · Google Fonts · Persisted preference |
| Confetti | Celebration animation on player win |

---

## Project Structure

```
lib/
├── main.dart                   App entry point & Provider setup
│
├── ai/
│   ├── easy_ai.dart            Random move selection
│   ├── medium_ai.dart          Alternating random / hard strategy
│   └── hard_ai.dart            Six-step rule-based strategy
│
├── logic/
│   ├── board_constants.dart    kRows, kCols, kWinLength
│   └── game_logic.dart         Pure testable game functions
│
├── models/
│   ├── cell_state.dart         empty / human / ai enum
│   ├── difficulty.dart         easy / medium / hard enum
│   ├── game_move.dart          Move history entry
│   ├── game_result.dart        ongoing / humanWin / aiWin / draw
│   └── game_stats.dart         wins / losses / draws data class
│
├── providers/
│   ├── game_provider.dart      Central game state ChangeNotifier
│   └── settings_provider.dart  Difficulty & first-player preference
│
├── services/
│   └── stats_service.dart      shared_preferences read / write
│
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── settings_screen.dart
│   ├── statistics_screen.dart
│   └── about_screen.dart
│
├── widgets/
│   ├── board_cell.dart         Animated single disc cell
│   ├── game_board.dart         7 × 6 interactive grid
│   ├── status_banner.dart      Turn / result message
│   ├── turn_timer.dart         Countdown bar
│   ├── gradient_button.dart    Reusable CTA button
│   ├── difficulty_selector.dart Segmented difficulty row
│   └── stat_card.dart          Single stat display card
│
├── themes/
│   ├── app_theme.dart          Light + Dark ThemeData
│   └── theme_provider.dart     Toggle & persist theme
│
└── utils/
    ├── app_routes.dart         Named route constants
    └── helpers.dart            Time formatter, result labels

test/
└── game_logic_test.dart        35 unit tests (pure logic only)
```

---

## Architecture

The app follows a layered clean architecture:

```
UI (screens / widgets)
        ↓ reads via context.watch<>()
Providers (GameProvider, ThemeProvider)
        ↓ calls
Logic + AI (pure functions, no Flutter deps)
        ↓ persists via
Services (StatsService → shared_preferences)
```

**GameProvider** owns all runtime state: the board, move history, timers, AI dispatch, and end-of-game persistence. It exposes only getters to the UI and accepts commands (`humanMove`, `undoMove`, `startGame`).

---

## Game Logic

### Move Validation
`isValidMove(board, column)` returns `true` when the column is in range and its top cell is empty. `getAvailableRow(board, column)` scans from the bottom row upward to find the target row.

### Win Detection
`checkWinner(board, player)` iterates every occupied cell and extends in four directions (horizontal, vertical, diagonal ↘, anti-diagonal ↙). Returns the four winning `[row, col]` pairs on a match, or `null`.

### Draw Detection
`checkDraw(board)` returns `true` when every cell in row 0 is occupied (no column can accept another disc).

### Undo
`undoMove(board, move)` sets the recorded `[row, col]` back to empty. `GameProvider.undoMove()` pops the last two moves (AI + human) from the history stack and reverts them in sequence.

---

## AI Strategy

### Easy
`EasyAI.getMove()` — shuffles the list of legal columns and returns the first.

### Medium
`MediumAI.getMove(board, aiTurnIndex)` — even index → random; odd index → hard strategy.

### Hard
`HardAI.getMove()` — six-step priority:
1. Win immediately if a column completes four-in-a-row.
2. Block the player from winning on their next turn.
3. Play a column that creates three-in-a-row with an open end.
4. Prefer the centre column (column 3).
5. Prefer columns adjacent to the centre.
6. Choose any remaining legal column.

---

## Dependencies (`pubspec.yaml`)

| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | State management |
| `shared_preferences` | ^2.2.2 | Persistent storage |
| `google_fonts` | ^6.2.1 | Space Grotesk + Orbitron typefaces |
| `flutter_animate` | ^4.5.0 | Entrance animations on screens |
| `confetti` | ^0.7.0 | Celebration effect on player win |

---

## Unit Tests

Run with:
```bash
flutter test
```

35 tests across 9 groups:

| Group | Tests | What is covered |
|---|---|---|
| `isValidMove()` | 6 | Bounds, empty, full, partial columns |
| `getAvailableRow()` | 3 | Bottom row, stacking, full column |
| `applyMove()` | 4 | Placement, stacking, null on full, immutability |
| `undoMove()` | 2 | Revert cell, expose lower disc |
| `checkWinner()` | 9 | All four directions, 3-in-a-row not a win, cell count |
| `checkDraw()` | 3 | Empty, partial, full board |
| `evaluateResult()` | 4 | All four outcomes |
| `getAvailableColumns()` | 3 | All available, reduced, empty |
| `EasyAI` | 3 | Valid column, -1 on full, legal choice |
| `HardAI` | 5 | Win, block, centre preference, vertical win/block |
| `MediumAI` | 3 | Legal column, even → random, odd → hard |

---

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

Minimum SDK: Android 5.0 (API 21) / iOS 12.0
