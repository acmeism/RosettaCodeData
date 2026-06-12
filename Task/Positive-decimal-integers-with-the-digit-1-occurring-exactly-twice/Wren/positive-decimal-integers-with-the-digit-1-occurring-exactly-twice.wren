import "./math" for Int
import "./fmt" for Fmt

System.print("Decimal numbers under 1,000 whose digits include two 1's:")
var results = (11..911).where { |i| Int.digits(i).count { |d| d == 1 } == 2 }.toList
Fmt.tprint("$5d", results, 7)
System.print("\nFound %(results.count) such numbers.")
