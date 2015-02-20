val tests = List(
  "the cat sat on the mat" -> "mat cat",
  "the cat sat on the mat" -> "cat mat",
  "A B C A B C A B C"      -> "C A C A",
  "A B C A B D A B E"      -> "E A D A",
  "A B"                    -> "B",
  "A B"                    -> "B A",
  "A B B A"                -> "B A"
)

tests.foreach{case (input, using) =>
  val done = order(input.split(" "), using.split(" "))
  println(f"""Data M: $input%-24s Order N: $using%-9s -> Result M': ${done mkString " "}""")
}
