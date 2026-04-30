let p = [
    ("Aleph",   1.0 /. 5.0),
    ("Beth",    1.0 /. 6.0),
    ("Gimel",   1.0 /. 7.0),
    ("Daleth",  1.0 /. 8.0),
    ("He",      1.0 /. 9.0),
    ("Waw",     1.0 /. 10.0),
    ("Zayin",   1.0 /. 11.0),
    ("Heth", 1759.0 /. 27720.0),
  ]

let prob_take = (arr, k) => {
  let rec aux = (i, k) => {
    let (v, p) = arr[i]
    if k < p { v } else { aux(i+1, (k -. p)) }
  }
  aux(0, k)
}

{
  let n = 1_000_000
  let h = Belt.HashMap.String.make(~hintSize=10)

  Js.Array2.forEach(p, ((v, _)) =>
    Belt.HashMap.String.set(h, v, 0)
  )

  let tot = Js.Array2.reduce(p, (acc, (_, prob)) => acc +. prob, 0.0)

  for _ in 1 to n {
    let sel = prob_take(p, tot *. Js.Math.random())
    let _n = Belt.HashMap.String.get(h, sel)
    let n = Belt.Option.getExn(_n)
    Belt.HashMap.String.set(h, sel, (n+1))  /* count the number of each item */
  }
  Printf.printf("Event    expected occurred\n")
  Js.Array2.forEach(p, ((v, p)) => {
      let _d = Belt.HashMap.String.get(h, v)
      let d = Belt.Option.getExn(_d)
      Printf.printf("%s \t %8.5g %8.5g\n", v, p, float(d) /. float(n))
    }
  )
}
