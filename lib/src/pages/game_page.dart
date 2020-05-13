import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';

import 'package:memory_match/src/widgets/background_widget.dart';
import 'package:memory_match/src/models/game_model.dart';
import 'package:memory_match/src/pages/home_page.dart';

class GamePage extends StatefulWidget {

  final int difficulty;

  GamePage({@required this.difficulty});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Game game;
  Timer timer;
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  int previousIndex = -1;
  bool flip = false;

  @override
  void initState() {
    super.initState();

    this.game = new Game(widget.difficulty);

    cardStateKeys = game.cards.map((_) => new GlobalKey<FlipCardState>()).toList();

    startTimer();
  }

  @override
  void dispose() {
    // game = null;
    timer.cancel();
    super.dispose();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        game.time--;
        if (game.time == 0) {
          // you lost
          timer.cancel();
          showResult(false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Background(),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${game.time}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: game.time > 10 ? Colors.grey : Colors.red)),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: game.cardsForRow,
                  ),
                  itemBuilder: (context, index) => FlipCard(
                    key: cardStateKeys[index],
                    onFlip: () {
                      if (!flip) {
                        flip = true;
                        previousIndex = index;
                      } else {
                        flip = false;
                        if (previousIndex != index) {
                          if (game.cards[previousIndex].index != game.cards[index].index) {
                            cardStateKeys[previousIndex]
                                .currentState
                                .toggleCard();
                            previousIndex = index;
                          } else {
                            game.cards[previousIndex].flip = false;
                            game.cards[index].flip = false;
                            // print(cardFlips);

                            if (game.cards.every((card) => card.flip == false)) {
                              timer.cancel();
                              showResult(true);
                            }
                          }
                        }
                      }
                    },
                    direction: FlipDirection.HORIZONTAL,
                    flipOnTouch: game.cards[index].flip,
                    front: Card(
                      elevation: 4,
                      color: Colors.blueAccent,
                      margin: EdgeInsets.all(4),
                      child: Icon(Icons.grade, size: 60, color: Colors.white),
                    ),
                    back: Card(
                        elevation: 4,
                        color: Colors.white,
                        margin: EdgeInsets.all(4),
                        child:
                            SvgPicture.asset(game.cards[index].assetImagePath)),
                  ),
                  itemCount: game.cards.length,
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }

  showResult(bool matched) {
    String messageCustom = game.time >= 30 ? '¡Eres implacable! 🙌' : game.time >= 15 ? '¡Excelente memoria! 👏' : '¡Bien hecho! 👍';
    String message = matched ? messageCustom : '¡Tiempo fuera! ⌛️';
    String content = matched ? '¡Felicidades! Estás list@ para el próximo nivel sin precedentes 😎' : '¡Perdiste! 😫\nNo te desanimes, vuelve a intentarlo y lo conseguirás 😉';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Column(
          children: <Widget>[
            if(game.time > 0)
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                ZoomIn(duration: Duration(milliseconds: 500), child: Icon(game.time > 0 ? Icons.star : Icons.star_border, size: 40, color: Colors.yellow)),
                ZoomIn(delay: Duration(milliseconds: 250), duration: Duration(milliseconds: 500), child: Icon(game.time >= 15 ? Icons.star : Icons.star_border, size: 50, color: Colors.yellow)),
                ZoomIn(delay: Duration(milliseconds: 500), duration: Duration(milliseconds: 500), child: Icon(game.time >= 30 ? Icons.star : Icons.star_border, size: 40, color: Colors.yellow)),
              ]),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        content: Text(content, textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.blueAccent,
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => HomePage())),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
