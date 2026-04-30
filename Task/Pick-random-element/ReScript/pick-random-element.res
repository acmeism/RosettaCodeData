let fruits = ["apple", "banana", "coconut", "orange", "lychee"]

let pickRand = arr => {
  let len = Js.Array.length(arr)
  let i = Js.Math.random_int(0, len)
  arr[i]
}

Js.log(pickRand(fruits))
