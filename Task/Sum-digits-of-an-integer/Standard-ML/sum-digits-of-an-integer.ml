fun sumDigits (0, _) = 0
  | sumDigits (n, base) = n mod base + sumDigits (n div base, base)

val testInput = [(1, 10), (1234, 10), (0xfe, 16), (0xf0e, 16)]
val () = print (String.concatWith " " (map (Int.toString o sumDigits) testInput) ^ "\n")
