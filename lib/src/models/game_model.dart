class Game {
  int difficulty;
  int time = 60;
  List<CardGame> cards = [];
  List<String> animals = ['bird', 'cat', 'elefante', 'escarabajo', 'jirafa', 'rana', 'tigre', 'zebra', 'camel', 'cow', 'dog', 'beaver', 'butterfly', 'rooster', 'tropical-fish'];
  int cardsForRow;

  Game(this.difficulty){
    List<CardGame> cardsTemp = [];
    int n;
    animals.shuffle();
    switch(difficulty){
      case 0: n = 3; cardsForRow = 3; break; // Easy: 3 animals, 6 cards
      case 1: n = 8; cardsForRow = 4; break; // Normal: 8 animals, 16 cards
      case 2: n = 15; cardsForRow = 5; break; // Hard: 15 animals, 30 cards
    }
    cardsTemp = new List<CardGame>.generate(n, (index){
        return CardGame(index, true, 'assets/animals/${animals[index]}.svg');
    });

    cards.addAll(cardsTemp);
    cards.addAll(cardsTemp); // duplicate cards for match
    cards.shuffle();
  }
}

class CardGame {
  int index;
  bool flip;
  String assetImagePath;

  CardGame(this.index, this.flip, this.assetImagePath);
}