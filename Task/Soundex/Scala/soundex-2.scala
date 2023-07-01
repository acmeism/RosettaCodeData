def main(args: Array[String]): Unit = {
   val tests=Map(
      "Soundex"     -> "S532",
      "Euler"	    -> "E460",
      "Gauss"	    -> "G200",
      "Hilbert"	    -> "H416",
      "Knuth"	    -> "K530",
      "Lloyd"	    -> "L300",
      "Lukasiewicz" -> "L222",
      "Ellery"	    -> "E460",
      "Ghosh"	    -> "G200",
      "Heilbronn"   -> "H416",
      "Kant"	    -> "K530",
      "Ladd"	    -> "L300",
      "Lissajous"   -> "L222",
      "Wheaton"	    -> "W350",
      "Ashcraft"    -> "A226",
      "Burroughs"   -> "B622",
      "Burrows"	    -> "B620",
      "O'Hara"	    -> "O600")

   tests.foreach{(v)=>
      val code=soundex(v._1)
      val status=if (code==v._2) "OK" else "ERROR"
      printf("Name: %-20s  Code: %s   Found: %s  - %s\n", v._1, v._2, code, status)
   }
}
