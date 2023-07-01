object Main extends App {
  val radices = List(2, 8, 10, 16, 19, 36)
  for (base <- radices) print(f"$base%6d")
  println(s"""\n${"-" * (6 * radices.length)}""")
  for (i <- BigInt(0) to 35; // BigInt has a toString(radix) method
       radix <- radices;
       eol = if (radix == radices.last) '\n' else '\0'
  ) print(f"${i.toString(radix)}%6s$eol")
}
