let array_rand ary =
  let len = Array.length ary in
  ary.(Random.int len)
