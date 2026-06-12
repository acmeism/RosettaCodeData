import "./gmp" for Mpf
import "./fmt" for Fmt

var start = System.clock
Fmt.print("$20a", Mpf.pi(3322000).toString(1000000))
System.print("\nTook %(System.clock - start) seconds")
