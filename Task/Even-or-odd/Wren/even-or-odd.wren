import "/fmt" for Fmt

var isEven1 = Fn.new { |i| i & 1 == 0 }

var isEven2 = Fn.new { |i| i % 2 == 0 }

var tests = [10, 11, 0,  57,  34,  -23,  -42]
System.print("Tests    : %(Fmt.v("s", -4, tests, 0, " ", ""))")
var res1 = tests.map { |t| isEven1.call(t) ? "even" : "odd" }.toList
System.print("Method 1 : %(Fmt.v("s", -4, res1, 0, " ", ""))")
var res2 = tests.map { |t| isEven2.call(t) ? "even" : "odd" }.toList
System.print("Method 2 : %(Fmt.v("s", -4, res2, 0, " ", ""))")
