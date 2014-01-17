object BestShuffleSpecification extends Properties("BestShuffle") {

  property("size") = forAll { (src: String) =>
    val s = Main.bestShuffle(src)
    s._1.size == src.size
  }

  property("freq") = forAll { (src: String) =>
    val s = Main.bestShuffle(src)
    Main.freqMap(s._1.toList) == Main.freqMap(src.toList)
  }

  property("estimate") = forAll { (src: String) =>
    val s = Main.bestShuffle(src)
    Main.estimate(src.toList) == s._2
  }

}
