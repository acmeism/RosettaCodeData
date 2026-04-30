let _m = Sys.argv[2]
let _n = Sys.argv[3]

let m = int_of_string(_m)
let n = int_of_string(_n)

let rec a = (m, n) =>
  switch (m, n) {
  | (0, n) => (n+1)
  | (m, 0) => a(m-1, 1)
  | (m, n) => a(m-1, a(m, n-1))
  }

Js.log("ackermann(" ++ _m ++ ", " ++ _n ++ ") = "
    ++ string_of_int(a(m, n)))
