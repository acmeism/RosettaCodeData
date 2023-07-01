let arr = [1, 2, 3]

let _ = Js.Array2.push(arr, 4)

arr[3] = 5

Js.log(Js.Int.toString(arr[3]))
