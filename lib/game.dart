///::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\\\
/// Copyright (c) 2020 lucdotdev                                                           \\\
///                                                                                        \\\
/// Permission is hereby granted, free of charge, to any person obtaining a copy           \\\
/// of this software and associated documentation files (the "Software"), to deal          \\\
/// in the Software without restriction, including without limitation the rights           \\\
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell              \\\
/// copies of the Software, and to permit persons to whom the Software is                  \\\
/// furnished to do so, subject to the following conditions:                               \\\
///                                                                                        \\\
/// The above copyright notice and this permission notice shall be included in all         \\\
/// copies or substantial portions of the Software.                                        \\\
///                                                                                        \\\
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR             \\\
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,               \\\
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE            \\\
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER                 \\\
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,          \\\
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE          \\\
/// SOFTWARE.                                                                              \\\
///                                                                                        \\\
///::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\\\

import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamePong extends StatefulWidget {
  GamePong({Key key}) : super(key: key);

  @override
  _GamePongState createState() => _GamePongState();
}

class _GamePongState extends State<GamePong> with TickerProviderStateMixin {
  double player1PositionDy;
  double player2PositionDy;

  double ballPositionDx;
  double ballPositionDy;
  double ballSize = 30;

  int difficulty = 70;

  int scorePlayer1 = 0;
  int scorePlayer2 = 0;

  int playerPaleteSizeY = 100;
  int playerPaleteSizeX = 50;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    animationController = AnimationController(
        vsync: this, duration: Duration(microseconds: difficulty));
    animationController.addListener(() {
      setState(() {});
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  ///:::PLAYER1 LOGIC::///
  void player1move(int direction, double heigth) {
    if (direction == 1 && player1PositionDy >= 0) {
      player1PositionDy = player1PositionDy - 50;
      setState(() {});
    }
    if (direction == 2 && player1PositionDy < heigth - playerPaleteSizeY) {
      player1PositionDy = player1PositionDy + 50;
      setState(() {});
    }
  }

  ///:::PLAYER2 LOGIC::///
  void player2move(int direction, double heigth) {
    if (direction == 1 && player2PositionDy >= 0) {
      player2PositionDy = player2PositionDy - 50;
      setState(() {});
    }
    if (direction == 2 && player2PositionDy < heigth - playerPaleteSizeY) {
      player2PositionDy = player2PositionDy + 50;
      setState(() {});
    }
  }

  ///:::BALL LOGIC::///

  void ballProgression(double width, double heigth) {
    Random _ballRandom = Random();
    ballPositionDx = 50;
    ballPositionDy = _ballRandom.nextInt(heigth.toInt()).toDouble();

    player1PositionDy = heigth / 2;
    player2PositionDy = heigth / 2;

    List<int> ballPosibleDirection = [-1, 1];
    int ballDirection = ballPosibleDirection[_ballRandom.nextInt(1)];
    int ballDeviation = 10;
    bool isIcrement = true;

    print(ballPositionDy);

    Timer.periodic(Duration(milliseconds: difficulty), (timer) {
      // print({
      //   "player1Dx": player1PositionDy,
      //   "ballDx": ballPositionDx,
      //   "ballDy": ballPositionDy,
      // });

      if (ballPositionDy <= 0 || ballPositionDy >= heigth) {
        ballDirection = -ballDirection;
        print(ballDirection);
      }
      if (ballDirection == 1) {
        ballPositionDy = ballPositionDy + ballDeviation;
        setState(() {});
      }

      if (ballDirection == -1) {
        ballPositionDy = ballPositionDy - ballDeviation;
        setState(() {});
      }

      if (ballPositionDy >= player1PositionDy &&
          ballPositionDy <= player1PositionDy + playerPaleteSizeY &&
          ballPositionDx <= playerPaleteSizeX) {
        isIcrement = true;
        print("YOLO 4");
        setState(() {});
      }
      if (ballPositionDy >= player2PositionDy &&
          ballPositionDy <= player2PositionDy + playerPaleteSizeY &&
          ballPositionDx >= width - playerPaleteSizeX) {
        print("YOLO 5");
        isIcrement = false;
        setState(() {});
      }

      if (ballPositionDx <= 0) {
        ballPositionDx = 0;
        ballPositionDy = 50;
        scorePlayer2 = scorePlayer2 + 1;
        print({"Score Player1": scorePlayer1, "Score Player2": scorePlayer2});
        setState(() {});
        print("YOLO 2");
        timer.cancel();
      }
      if (ballPositionDx >= width) {
        ballPositionDx = 0;
        ballPositionDy = 50;
        scorePlayer1 = scorePlayer1 + 1;
        print({"Score Player1": scorePlayer1, "Score Player2": scorePlayer2});
        setState(() {});
        print("YOLO 3");
        timer.cancel();
      }

      isIcrement
          ? ballPositionDx = ballPositionDx + 10
          : ballPositionDx = ballPositionDx - 10;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Material(
        child: Container(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                      onPressed: () => ballProgression(width, heigth),
                      child: Text("Start"))),

              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text("Scores"),
                    Text(scorePlayer1.toString() +
                        " : " +
                        scorePlayer2.toString())
                  ],
                ),
              ),

              ///:::PLAYER1::///
              AnimatedPositioned(
                top: player1PositionDy ?? 0,
                left: 0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  color: Colors.blue,
                  width: playerPaleteSizeX.toDouble(),
                  height: playerPaleteSizeY.toDouble(),
                ),
              ),

              ///:::PLAYER2::///
              AnimatedPositioned(
                top: player2PositionDy ?? 0,
                right: 0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  color: Colors.green,
                  width: playerPaleteSizeX.toDouble(),
                  height: playerPaleteSizeY.toDouble(),
                ),
              ),

              ///:::BALL::///
              Positioned(
                top: ballPositionDy ?? heigth / 2,
                left: ballPositionDx ?? width / 2,
                child: Container(
                  width: ballSize,
                  height: ballSize,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => player1move(1, heigth),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Theme.of(context).accentColor,
                        child: Icon(Icons.arrow_drop_up),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => player1move(2, heigth),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Theme.of(context).accentColor,
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => player2move(1, heigth),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.green,
                        child: Icon(Icons.arrow_drop_up),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => player2move(2, heigth),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.green,
                        child: Icon(Icons.arrow_drop_down),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
