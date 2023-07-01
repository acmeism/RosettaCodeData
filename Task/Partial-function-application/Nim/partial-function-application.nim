import sequtils

type

  Func = proc(n: int): int
  FuncS = proc(f: Func; s: seq[int]): seq[int]

proc fs(f: Func; s: seq[int]): seq[int] = s.map(f)

proc partial(fs: FuncS; f: Func): auto =
  result = proc(s: seq[int]): seq[int] = fs(f, s)

proc f1(n: int): int = 2 * n
proc f2(n: int): int = n * n

when isMainModule:

  const Seqs = @[@[0, 1, 2, 3], @[2, 4, 6, 8]]

  let fsf1 = partial(fs, f1)
  let fsf2 = partial(fs, f2)

  for s in Seqs:
    echo fs(f1, s)    # Normal.
    echo fsf1(s)      # Partial.
    echo fs(f2, s)    # Normal.
    echo fsf2(s)      # Partial.
    echo ""
