main() {
  BeerSong beerSong = BeerSong();
  //pass a 'starting point' and 'end point' as parameters respectively
  String printTheLyrics = beerSong.recite(99, 1).join('\n');
  print(printTheLyrics);
  }

class Song {
  String bottleOnTheWall(int index) {
    String bottleOnTheWallText =
        '$index bottles of beer on the wall, $index bottles of beer,';
    return bottleOnTheWallText;
  }

  String bottleTakenDown(int index) {
    String englishGrammar = (index >= 2) ? 'bottle' : 'bottles';
    String bottleTakenDownText =
        'Take one down and pass it around, ${index - 1} $englishGrammar of beer on the wall.';
    return bottleTakenDownText;
  }
}

class BeerSong extends Song {
  @override
  String bottleOnTheWall(int index) {
    String originalText = super.bottleOnTheWall(index);
    if (index < 2) {
      String bottleOnTheWallText =
          '$index bottle of beer on the wall, $index bottle of beer,';
      return bottleOnTheWallText;
    }
    return originalText;
  }

  @override
  String bottleTakenDown(int index) {
    if (index < 2) {
      String bottleTakenDownText =
          'Take it down and pass it around, no more bottles of beer on the wall.';
      return bottleTakenDownText;
    }
    String originalText = super.bottleTakenDown(index);
    return originalText;
  }

  List<String> recite(int actualBottleOnTheWall, int remainingBottleOnTheWall) {
    List<String> theLyrics = [];
    for (int index = actualBottleOnTheWall;
        index >= remainingBottleOnTheWall;
        index--) {
      String onTheWall = bottleOnTheWall(index);
      String takenDown = bottleTakenDown(index);
      theLyrics.add(onTheWall);
      theLyrics.add(takenDown);
      theLyrics.add('');
    }
    return theLyrics;
  }
}

}
