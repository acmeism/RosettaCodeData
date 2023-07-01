let pi = 4.0 *. atan(1.0)

let random_gaussian = () => {
  1.0 +.
  sqrt(-2.0 *. log(Random.float(1.0))) *.
  cos(2.0 *. pi *. Random.float(1.0))
}

let a = Belt.Array.makeBy(1000, (_) => random_gaussian ())

for i in 0 to 10 {
  Js.log(a[i])
}
