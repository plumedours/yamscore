/// Catégories Yams (Yahtzee)
enum Category {
  ones,
  twos,
  threes,
  fours,
  fives,
  sixes,
  threeOfAKind,
  fourOfAKind,
  fullHouse,
  smallStraight,
  largeStraight,
  chance,
  yahtzee,
}

const upperCategories = <Category>[
  Category.ones,
  Category.twos,
  Category.threes,
  Category.fours,
  Category.fives,
  Category.sixes,
];

const lowerCategories = <Category>[
  Category.threeOfAKind,
  Category.fourOfAKind,
  Category.fullHouse,
  Category.smallStraight,
  Category.largeStraight,
  Category.chance,
  Category.yahtzee,
];

String categoryLabel(Category c) {
  switch (c) {
    case Category.ones:
      return 'As (1)';
    case Category.twos:
      return 'Deux (2)';
    case Category.threes:
      return 'Trois (3)';
    case Category.fours:
      return 'Quatre (4)';
    case Category.fives:
      return 'Cinq (5)';
    case Category.sixes:
      return 'Six (6)';
    case Category.threeOfAKind:
      return 'Brelan';
    case Category.fourOfAKind:
      return 'Carré';
    case Category.fullHouse:
      return 'Full';
    case Category.smallStraight:
      return 'Petite suite';
    case Category.largeStraight:
      return 'Grande suite';
    case Category.chance:
      return 'Chance';
    case Category.yahtzee:
      return 'Yams';
  }
}
