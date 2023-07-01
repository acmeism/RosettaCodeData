import deques, sequtils

template shfl(idx): untyped = (K*(idx+1)) mod I

func mutuallyprime(I, K: int16): bool {.compiletime.} =
  ## compile time check shuffling works properly
  let
    x = {1'i16..I}
    s = x.toSeq
  var r: set[int16]
  for n in 0..<I:
    r.incl s[n.shfl]
  r == x

func `%`(i: int, m: int): int = (if i < 0: i+m else: i)
  ## positive modulo, and we don't need to test if > m
  ## because (i-j) is always less than m

template next(state): untyped =
  state.addLast (state[^I]-state[^J]) % M
  discard state.popFirst()

func seedGen[I, J, K, M: static int](seed: range[0..M-1]): Deque[int] =
  var s = @[seed, 1]
  for _ in 2..<I:
    s.add (s[^2]-s[^1]) % M
  #reorder and put into ring buffer
  for i in 0..<I:
    result.addLast s[i.shfl]
  #cycle through the next 165 values
  for _ in 0..<3*I:
    result.next

func initSubGen[I, J, K, M: static int](seed: range[0..M-1]): auto =
  ##check parameters at compile time
  ##seed will be checked to be in the range 0..M-1
  static:
    for x in [I, J, K, M]:
      assert x > 0, "all params must be positive"
    assert I > J, "I must be > J"
    assert mutuallyprime(I, K), "I, K must be relatively prime"
  var r = seedGen[I, J, K, M](seed)
  result = proc(): int =
    r.next
    r.peekLast

let subGen* = initSubGen[55, 24, 34, 1e9.int]

when isMainModule:
  let rand = subGen(292929)
  for _ in 1..3:
    echo rand()
