let arr = [3, 8, 4, 1, 5, 12]

let num = Js.Array.length(arr)
let tot = Js.Array.reduce(\"+", 0, arr)
let mean = float_of_int(tot) /. float_of_int(num)

Js.log(Js.Float.toString(mean))
