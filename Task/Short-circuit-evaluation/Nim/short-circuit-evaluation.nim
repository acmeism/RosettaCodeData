proc a(x): bool =
  echo "a called"
  result = x

proc b(x): bool =
  echo "b called"
  result = x

let x = a(false) and b(true) # echoes "a called"
let y = a(true) or b(true)   # echoes "a called"
