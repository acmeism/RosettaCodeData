import Math.{addExact => ++, multiplyExact => **, negateExact => ~~, subtractExact => --}

def requireOverflow(f: => Unit) =
  try {f; println("Undetected overflow")} catch{case e: Exception => /* caught */}

println("Testing overflow detection for 32-bit unsigned integers")
requireOverflow(~~(--(~~(2147483647), 1))) // -(-2147483647-1)
requireOverflow(++(2000000000, 2000000000)) // 2000000000 + 2000000000
requireOverflow(--(~~(2147483647), 2147483647)) // -2147483647 + 2147483647
requireOverflow(**(46341, 46341)) // 46341 * 46341
requireOverflow(**(--(~~(2147483647),1), -1)) // same as (-2147483647-1) / -1

println("Test - Expect Undetected overflow:")
requireOverflow(++(1,1)) // Undetected overflow
