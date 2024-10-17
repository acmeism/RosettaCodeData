def is-even [x: int] {
  ($x bit-and 1) == 0
}

def is-odd [x: int] {
  ($x bit-and 1) == 1
}
