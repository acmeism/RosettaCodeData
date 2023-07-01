import "./fmt" for Fmt   // imports the Fmt module and makes the 'Fmt' class available
import "./math" for Int  // imports the Math module and makes the 'Int' class available

Fmt.print("The maximum safe integer in Wren is $,d.", Int.maxSafe)
