import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'package:memory_match/src/widgets/background_widget.dart';
import 'package:memory_match/src/pages/game_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<bool> _selections = List.generate(3, (i) => i == 1); // 1: normal default selected
  
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
                  SizedBox(height: 50),
                  Center(
                    child: FlipInY(
                      // delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 1000),
                      child: Text('Memory\nMatch!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.monofett(
                          textStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 85, height: 1))
                      ),
                    ),
                  ),
                  Text("v1.0.0"),
                  SizedBox(height: 30),
                  ToggleButtons(
                    borderColor: Colors.blueAccent,
                    fillColor: Colors.blueAccent,
                    borderWidth: 2,
                    selectedBorderColor: Colors.blueAccent,
                    selectedColor: Colors.white,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Fácil', style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Normal', style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Dificil', style: TextStyle(fontSize: 20)),
                      ),
                    ],
                    isSelected: _selections,
                    onPressed: (index){
                      setState(() {
                        for (int indexBtn = 0;indexBtn < _selections.length; indexBtn++) {
                          _selections[indexBtn] = indexBtn == index;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(30),
                  ),
                  SizedBox(height: 30),
                  FlatButton(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    child: Text('Empezar', style: TextStyle(color: Colors.white, fontSize: 20)),
                    shape: StadiumBorder(),
                    onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => GamePage(difficulty: _selections.indexWhere((selection) => selection == true)))),
                  ),
                  SizedBox(height: 30),            
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
