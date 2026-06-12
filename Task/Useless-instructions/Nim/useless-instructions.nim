type T = object
  case i: 0..2
  of 0: value: int
  of 1: discard
  of 2: nil
