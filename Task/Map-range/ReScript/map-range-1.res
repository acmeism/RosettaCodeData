let map_range = ((a1, a2), (b1, b2), s) => {
  b1 +. ((s -. a1) *. (b2 -. b1) /. (a2 -. a1))
}

Js.log("Mapping [0,10] to [-1,0] at intervals of 1:")

for i in 0 to 10 {
  Js.log("f(" ++ Js.String.make(i) ++ ") = " ++
    Js.String.make(map_range((0.0, 10.0), (-1.0, 0.0), float(i))))
}
