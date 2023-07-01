let my_compare = (a, b) => {
  if a < b { "A is less than B" } else
  if a > b { "A is greater than B" } else
  if a == b { "A equals B" }
  else { "cannot compare NANs" }
}

let a = int_of_string(Sys.argv[2])
let b = int_of_string(Sys.argv[3])

Js.log(my_compare(a, b))
