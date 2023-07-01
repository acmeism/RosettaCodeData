let a = int_of_string(Sys.argv[2])
let b = int_of_string(Sys.argv[3])

let sum = a + b
let difference = a - b
let product = a * b
let division = a / b
let remainder = mod(a, b)

Js.log("a + b = " ++ string_of_int(sum))
Js.log("a - b = " ++ string_of_int(difference))
Js.log("a * b = " ++ string_of_int(product))
Js.log("a / b = " ++ string_of_int(division))
Js.log("a % b = " ++ string_of_int(remainder))
