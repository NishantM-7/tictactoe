import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const String PLAYER_X = "X";
  static const String PLAYER_Y = "O";

  late String currentPlayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _headerText(),
            _gameContainer(),
            _restartButton(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          'TIC TAC TOE',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$currentPlayer \'s turn',
          style: const TextStyle(
            fontSize: 32,
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      // color: Colors.white,
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return _tile(index);
        },
        itemCount: 9,
      ),
    );
  }

  Widget _restartButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          initializeGame();
        });
      },
      icon: const Icon(
        Icons.loop,
        color: Colors.white,
        size: 30,
      ),
      splashColor: Colors.amber,
      splashRadius: 20,
    );
  }

  Widget _tile(int index) {
    return InkWell(
      onTap: (() {
        if (gameEnd || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkWinner();
          checkDraw();
        });
      }),
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.white70
            : occupied[index] == PLAYER_X
                ? Colors.cyan
                : Colors.lime,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  void changeTurn() {
    if (currentPlayer == PLAYER_X) {
      currentPlayer = PLAYER_Y;
    } else {
      currentPlayer = PLAYER_X;
    }
  }

  void checkDraw() {
    if (gameEnd) {
      return;
    }
    bool gameDraw = true;
    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        gameDraw = false;
      }
    }

    if (gameDraw) {
      showGameOverText("Draw!");
      gameEnd = true;
    }
  }

  void checkWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var positions in winningList) {
      String playerPosition0 = occupied[positions[0]];
      String playerPosition1 = occupied[positions[1]];
      String playerPosition2 = occupied[positions[2]];
      if (playerPosition0.isNotEmpty) {
        if (playerPosition0 == playerPosition1 &&
            playerPosition0 == playerPosition2) {
          showGameOverText("Player $playerPosition0 Won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  void showGameOverText(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
            ),
          )),
    );
  }
}
