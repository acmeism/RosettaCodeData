proc bsdRand(seed: int): iterator: int =
  var seed = seed
  result = iterator: int =
    while true:
      seed = (1103515245 * seed + 12345) and 0x7fffffff
      yield seed

proc msvcrtRand(seed: int): iterator: int =
  var seed = seed
  result = iterator: int =
    while true:
      seed = (214013 * seed + 2531011) and 0x7fffffff
      yield seed
