val Bottles1 = "(\\d+) bottles of beer".r                                            // syntactic sugar
val Bottles2 = """(\d+) bottles of beer""".r                                         // using triple-quotes to preserve backslashes
val Bottles3 = new scala.util.matching.Regex("(\\d+) bottles of beer")               // standard
val Bottles4 = new scala.util.matching.Regex("""(\d+) bottles of beer""", "bottles") // with named groups
