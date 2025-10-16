import '../data/models/enums.dart';

/// Optionnel : une petite suggestion basique par défaut (peut rester null)
int? suggestScore(Category c) {
  switch (c) {
    case Category.ones:
      return 3; // arbitrage arbitraire
    case Category.twos:
      return 6;
    case Category.threes:
      return 9;
    case Category.fours:
      return 12;
    case Category.fives:
      return 15;
    case Category.sixes:
      return 18;
    case Category.threeOfAKind:
      return 20;
    case Category.fourOfAKind:
      return 25;
    case Category.fullHouse:
      return 25;
    case Category.smallStraight:
      return 30;
    case Category.largeStraight:
      return 40;
    case Category.chance:
      return 20;
    case Category.yahtzee:
      return 50;
  }
}
