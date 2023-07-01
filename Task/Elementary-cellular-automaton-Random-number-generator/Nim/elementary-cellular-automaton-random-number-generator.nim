const N = 64

template pow2(x: uint): uint = 1u shl x

proc evolve(state: uint; rule: Positive) =
  var state = state
  for _ in 1..10:
    var b = 0u
    for q in countdown(7, 0):
      let st = state
      b = b or (st and 1) shl q
      state = 0
      for i in 0u..<N:
        let t = (st shr (i - 1) or st shl (N + 1 - i)) and 7
        if (rule.uint and pow2(t)) != 0: state = state or pow2(i)
    stdout.write ' ', b
  echo ""

evolve(1, 30)
