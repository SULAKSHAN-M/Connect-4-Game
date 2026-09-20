<div align="center">

# 🎮 Connect 4 — Flutter Mobile App

### CSP2108 Introduction to Mobile Application Development · Assignment

A fully functional **Connect 4 game** where a human player 🔴 competes against a rules-based AI opponent 🟡.

Built with **Flutter & Dart** using clean architecture, Provider state management, persistent statistics, multiple AI difficulty levels, animations, and Material 3 design.

<br>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge\&logo=dart\&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-State%20Management-blue?style=for-the-badge)
![Material 3](https://img.shields.io/badge/Material%203-Design-purple?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge\&logo=github)

</div>

---

## 📖 About the Project

**Connect 4** is a Flutter-based mobile game developed as part of the **CSP2108 Introduction to Mobile Application Development** assignment.

The application allows a human player to compete against an AI opponent using the traditional Connect 4 game rules.

The project demonstrates:

* Flutter UI development
* Dart programming
* Provider state management
* Clean project architecture
* Rules-based artificial intelligence
* Persistent local storage
* Game state management
* Unit testing
* Responsive layouts
* Light and dark themes
* Animations and visual feedback

---

## ✨ Features

| Feature                  | Detail                                               |
| ------------------------ | ---------------------------------------------------- |
| 🎯 7 × 6 Board           | Discs fall to the lowest available row               |
| 🤖 Human vs AI           | Player = Red · AI = Yellow                           |
| 🧠 3 Difficulty Modes    | Easy / Medium / Hard                                 |
| 🏆 Win Detection         | Horizontal, vertical, diagonal and anti-diagonal     |
| 🤝 Draw Detection        | Detects a full board with no winner                  |
| 📊 Persistent Statistics | Wins / losses / draws saved across sessions          |
| ↩️ Undo                  | Removes both the player's and AI's last move         |
| ⏱️ Turn Timer            | 40 seconds per turn · 4 minute total player clock    |
| 📱 6 Screens             | Splash · Home · Game · Settings · Statistics · About |
| 🌗 Light & Dark Theme    | Material 3 theme with persisted preference           |
| 🎉 Confetti              | Celebration animation when the player wins           |
| 💾 Local Persistence     | Settings and statistics saved locally                |
| 🎨 Modern UI             | Animations, Google Fonts and reusable components     |

---

## 📱 Application Screens

The application contains six main screens:

### Splash Screen

Displays the application branding before navigating to the home screen.

### Home Screen

Provides access to:

* Start Game
* Settings
* Statistics
* About

### Game Screen

Contains:

* Connect 4 game board
* Current turn indicator
* Countdown timer
* Player and AI interactions
* Undo functionality
* Win / loss / draw status
* Confetti celebration

### Settings Screen

Allows the user to configure:

* AI difficulty
* First player
* Light / Dark theme

### Statistics Screen

Displays persistent game statistics:

* Wins
* Losses
* Draws
* Total games

### About Screen

Provides information about the application and project.

---

## 📂 Project Structure

```text
lib/
├── main.dart                    App entry point & Provider setup
│
├── ai/
│   ├── easy_ai.dart             Random move selection
│   ├── medium_ai.dart           Alternating random / hard strategy
│   └── hard_ai.dart             Six-step rule-based strategy
│
├── logic/
│   ├── board_constants.dart     kRows, kCols, kWinLength
│   └── game_logic.dart          Pure testable game functions
│
├── models/
│   ├── cell_state.dart          empty / human / ai enum
│   ├── difficulty.dart          easy / medium / hard enum
│   ├── game_move.dart           Move history entry
│   ├── game_result.dart         ongoing / humanWin / aiWin / draw
│   └── game_stats.dart          wins / losses / draws data class
│
├── providers/
│   ├── game_provider.dart       Central game state ChangeNotifier
│   └── settings_provider.dart   Difficulty & first-player preference
│
├── services/
│   └── stats_service.dart       shared_preferences read / write
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
│   ├── board_cell.dart          Animated single disc cell
│   ├── game_board.dart          7 × 6 interactive grid
│   ├── status_banner.dart       Turn / result message
│   ├── turn_timer.dart          Countdown bar
│   ├── gradient_button.dart     Reusable CTA button
│   ├── difficulty_selector.dart Segmented difficulty row
│   └── stat_card.dart           Single stat display card
│
├── themes/
│   ├── app_theme.dart           Light + Dark ThemeData
│   └── theme_provider.dart      Toggle & persist theme
│
└── utils/
    ├── app_routes.dart          Named route constants
    └── helpers.dart             Time formatter, result labels

test/
└── game_logic_test.dart         Game logic unit tests
```

---

## 🏗️ Architecture

The application follows a layered clean architecture.

```text
┌─────────────────────────────┐
│      UI Layer               │
│   Screens / Widgets         │
└─────────────┬───────────────┘
              │
              │ context.watch<>()
              ▼
┌─────────────────────────────┐
│     Provider Layer          │
│ GameProvider                │
│ SettingsProvider            │
│ ThemeProvider               │
└─────────────┬───────────────┘
              │
              │ Calls
              ▼
┌─────────────────────────────┐
│     Logic + AI Layer        │
│ Game Logic                  │
│ Easy / Medium / Hard AI     │
└─────────────┬───────────────┘
              │
              │ Persists
              ▼
┌─────────────────────────────┐
│      Service Layer          │
│ StatsService                │
│ shared_preferences          │
└─────────────────────────────┘
```

### GameProvider

`GameProvider` manages all runtime game state including:

* Game board
* Move history
* Human moves
* AI moves
* Turn timers
* Game results
* Undo operations
* Statistics updates
* End-of-game persistence

The UI accesses state using getters while game actions are performed using commands such as:

```dart
humanMove()
undoMove()
startGame()
```

---

# 🎯 Game Logic

## Move Validation

```dart
isValidMove(board, column)
```

Returns `true` when:

* The column is inside the valid range.
* The top cell of the column is empty.

```dart
getAvailableRow(board, column)
```

Scans upward from the bottom of the selected column and returns the first available row.

This recreates the real Connect 4 behaviour where discs fall to the lowest available position.

---

## 🏆 Win Detection

```dart
checkWinner(board, player)
```

The function evaluates every occupied cell and checks four possible directions:

```text
Horizontal       →
Vertical         ↓
Diagonal         ↘
Anti-Diagonal    ↙
```

When four connected pieces belonging to the same player are detected, the function returns the four winning:

```text
[row, column]
```

coordinates.

If there is no winner, it returns:

```dart
null
```

---

## 🤝 Draw Detection

```dart
checkDraw(board)
```

A draw occurs when every cell in the top row is occupied and no player has achieved four connected discs.

At this stage, no column can accept another move.

---

## ↩️ Undo System

```dart
undoMove(board, move)
```

Restores the selected:

```text
[row, column]
```

position to an empty cell.

`GameProvider.undoMove()` removes the latest:

```text
AI Move
+
Human Move
```

from the move history stack.

This allows the player to return to the state before their previous turn.

---

# 🤖 Artificial Intelligence

The game contains three AI difficulty levels.

---

## 🟢 Easy AI

```dart
EasyAI.getMove()
```

The Easy AI:

1. Finds all legal columns.
2. Randomly shuffles them.
3. Selects the first legal move.

This produces unpredictable but non-strategic gameplay.

---

## 🟠 Medium AI

```dart
MediumAI.getMove(board, aiTurnIndex)
```

The Medium AI alternates between:

```text
Even AI Turn → Random Strategy

Odd AI Turn → Hard Strategy
```

This creates a balanced difficulty between random play and strategic decision-making.

---

## 🔴 Hard AI

```dart
HardAI.getMove()
```

The Hard AI follows a six-step priority strategy.

### Priority 1 — Win

Play a move immediately if it completes four connected AI discs.

### Priority 2 — Block

Detect whether the human player can win on the next turn and block that column.

### Priority 3 — Build

Attempt to create three connected AI discs with an available extension.

### Priority 4 — Centre

Prefer:

```text
Column 3
```

because the centre provides more possible winning combinations.

### Priority 5 — Centre-Adjacent Columns

Prefer columns located close to the centre.

### Priority 6 — Legal Move

If no strategic option is available, select another valid column.

---

# ⏱️ Timer System

The game contains two timing mechanisms.

### Turn Timer

Each player turn has:

```text
40 seconds
```

### Player Clock

The human player receives a total game clock of:

```text
4 minutes
```

The UI displays the remaining time using a countdown indicator.

---

# 💾 Persistent Storage

The application uses:

```text
shared_preferences
```

to store application data locally.

Persisted information includes:

* Player wins
* AI wins
* Draws
* Theme preference
* Game settings

This means the user's statistics remain available even after closing and reopening the application.

---

# 🎨 Theme System

The application supports:

```text
☀️ Light Mode
🌙 Dark Mode
```

Themes are implemented using:

```dart
ThemeData
```

with **Material 3** components.

The selected theme is persisted so the application remembers the user's preference between sessions.

---

# 📦 Dependencies

The project uses the following Flutter packages.

| Package              |  Version | Purpose                               |
| -------------------- | -------: | ------------------------------------- |
| `provider`           | `^6.1.2` | State management                      |
| `shared_preferences` | `^2.2.2` | Persistent local storage              |
| `google_fonts`       | `^6.2.1` | Space Grotesk + Orbitron fonts        |
| `flutter_animate`    | `^4.5.0` | UI entrance and transition animations |
| `confetti`           | `^0.7.0` | Player win celebration                |

---

# 🧪 Unit Testing

The project includes unit tests for the core game logic.

Run the tests using:

```bash
flutter test
```

The tests cover the major game behaviours.

| Group                   | Tests | Coverage                                            |
| ----------------------- | ----: | --------------------------------------------------- |
| `isValidMove()`         |     6 | Bounds, empty, full and partial columns             |
| `getAvailableRow()`     |     3 | Bottom row, stacking and full column                |
| `applyMove()`           |     4 | Placement, stacking, null on full and immutability  |
| `undoMove()`            |     2 | Revert cell and expose lower disc                   |
| `checkWinner()`         |     9 | Horizontal, vertical and diagonal wins              |
| `checkDraw()`           |     3 | Empty, partial and full board                       |
| `evaluateResult()`      |     4 | All possible game outcomes                          |
| `getAvailableColumns()` |     3 | Available, reduced and full board                   |
| `EasyAI`                |     3 | Valid move and legal column selection               |
| `HardAI`                |     5 | Win, block, centre preference and vertical strategy |
| `MediumAI`              |     3 | Random / Hard strategy switching                    |

---

# 🛠️ Technologies Used

<div align="center">

| Technology         | Usage                  |
| ------------------ | ---------------------- |
| Flutter            | Application framework  |
| Dart               | Programming language   |
| Provider           | State management       |
| Shared Preferences | Local data persistence |
| Material 3         | User interface design  |
| Google Fonts       | Typography             |
| Flutter Animate    | Interface animations   |
| Confetti           | Win celebrations       |
| Git                | Version control        |
| GitHub             | Source code hosting    |

</div>

---

# 🚀 Getting Started

## Prerequisites

Before running the application, install:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android emulator or physical Android device
* Git

Verify Flutter installation with:

```bash
flutter doctor
```

---

## 1. Clone the Repository

```bash
git clone https://github.com/SULAKSHAN-M/Connect-4-Game.git
```

Navigate into the project:

```bash
cd Connect-4-Game
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Run the Application

Connect an Android device or start an emulator.

Then run:

```bash
flutter run
```

---

## 4. Run Unit Tests

```bash
flutter test
```

---

## 5. Build Android APK

Create a release APK using:

```bash
flutter build apk --release
```

The generated APK can be found inside:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🌐 Run as a Web Application

Enable Flutter web support:

```bash
flutter config --enable-web
```

Run the application:

```bash
flutter run -d chrome
```

Build the production web version:

```bash
flutter build web --release
```

The generated website will be available inside:

```text
build/web
```

---

# 📱 Platform Requirements

### Android

```text
Minimum Android Version: Android 5.0
Minimum API Level: API 21
```

### iOS

```text
Minimum iOS Version: iOS 12.0
```

---

# 🔮 Future Improvements

Possible future improvements include:

* Online multiplayer
* Local two-player mode
* Advanced Minimax AI
* AI difficulty customisation
* Player profiles
* Achievements
* Leaderboards
* Sound effects
* Background music
* Custom board themes
* Animated disc-drop physics
* Game replay
* Cloud statistics synchronization

---

# 👨‍💻 Developer

<div align="center">

### Sulakshan

Software Engineering Undergraduate
Full-Stack Development · Mobile Development · UI/UX · Software Testing

[![GitHub](https://img.shields.io/badge/GitHub-SULAKSHAN--M-181717?style=for-the-badge\&logo=github)](https://github.com/SULAKSHAN-M)

</div>

---

# ☕ Support My Work

If you like this project or find it useful, you can support my work by buying me a coffee.

<div align="center">

<a href="https://www.buymeacoffee.com/SULAKSHAN-MS">
  <img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-Support%20My%20Work-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=000000" alt="Buy Me a Coffee">
</a>

</div>


---

# ⭐ Support the Repository

If you like this project, consider giving it a ⭐ on GitHub.

It helps support the project and encourages future development.

<div align="center">

[![GitHub Stars](https://img.shields.io/github/stars/SULAKSHAN-M/Connect-4-Game?style=for-the-badge\&logo=github)](https://github.com/SULAKSHAN-M/Connect-4-Game/stargazers)

[![GitHub Forks](https://img.shields.io/github/forks/SULAKSHAN-M/Connect-4-Game?style=for-the-badge\&logo=github)](https://github.com/SULAKSHAN-M/Connect-4-Game/forks)

</div>

---

# 🐍 Contribution Activity

<div align="center">

<img src="https://raw.githubusercontent.com/SULAKSHAN-M/Connect-4-Game/output/github-contribution-grid-snake-dark.svg" alt="GitHub Contribution Snake Animation" />

</div>

---

<div align="center">

### 🎮 Connect 4

**Built with Flutter 💙 & Dart**

CSP2108 · Introduction to Mobile Application Development

<br>

Made with ❤️ by **Sulakshan**

</div>
