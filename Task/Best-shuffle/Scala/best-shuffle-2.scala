  def main(args: Array[String]): Unit = {
    println(bestShuffle("abracadabra"));
    println(bestShuffle("seesaw"));
    println(bestShuffle("elk"));
    println(bestShuffle("grrrrrr"));
    println(bestShuffle("up"));
    println(bestShuffle("a"));

    BestShuffleSpecification.check
  }
