let m = []

for _ in 0 to 9 {
  let n = []
  for _ in 0 to 9 {
    let _ = Js.Array2.push(n, 1 + Js.Math.random_int(0, 20))
  }
  let _ = Js.Array2.push(m, n)
}

try {
  for i in 0 to 9 {
    for j in 0 to 9 {
      Js.log(m[i][j])
      if m[i][j] == 20 { raise(Exit) }
    }
  }
} catch {
| Exit => Js.log("stop")
}
