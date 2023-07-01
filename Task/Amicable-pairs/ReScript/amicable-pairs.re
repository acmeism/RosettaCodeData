let isqrt = (v) => {
  Belt.Float.toInt(
    sqrt(Belt.Int.toFloat(v)))
}

let sum_divs = (n) => {
  let sum = ref(1)
  for d in 2 to isqrt(n) {
    if mod(n, d) == 0 {
      sum.contents = sum.contents + (n / d + d)
    }
  }
  sum.contents
}

{
  for n in 2 to 20000 {
    let m = sum_divs(n)
    if (m > n) {
      if sum_divs(m) == n {
        Printf.printf("%d %d\n", n, m)
      }
    }
  }
}
