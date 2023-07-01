val controlCode : (Char) => Boolean = (c:Char) => (c <= 32 || c == 127)
val extendedCode : (Char) => Boolean = (c:Char) => (c <= 32 || c > 127)


// ASCII test...
val teststring = scala.util.Random.shuffle( (1.toChar to 254.toChar).toList ).mkString

println( "ctrl filtered out: \n\n" +
  teststring.filterNot(controlCode) + "\n" )

println( "ctrl and extended filtered out: \n\n" +
  teststring.filterNot(controlCode).filterNot(extendedCode) + "\n" )
