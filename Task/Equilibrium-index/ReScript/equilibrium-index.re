let arr = [-7, 1, 5, 2, -4, 3, 0]
let sum = Js.Array2.reduce(arr, \"+", 0)
let len = Js.Array.length(arr)

let rec aux = (acc, i, left, right) => {
  if (i >= len) { acc } else {
    let x = arr[i]
    let right = right - x
    if (left == right) {
      let _ = Js.Array2.push(acc, i)
    }
    aux(acc, i+1, (left + x), right)
  }
}
let res = aux([], 0, 0, sum)
Js.log("Results:")
Js.Array2.forEach(res, Js.log)
