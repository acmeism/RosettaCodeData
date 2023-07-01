import sequtils

type Optimizer = object
  dims: seq[int]
  m: seq[seq[Natural]]
  s: seq[seq[Natural]]


proc initOptimizer(dims: openArray[int]): Optimizer =
  ## Create an optimizer for the given dimensions.
  Optimizer(dims: @dims)

proc findMatrixChainOrder(opt: var Optimizer) =
  ## Find the best order for matrix chain multiplication.

  let n = opt.dims.high
  opt.m = newSeqWith(n, newSeq[Natural](n))
  opt.s = newSeqWith(n, newSeq[Natural](n))

  for lg in 1..<n:
    for i in 0..<(n - lg):
      let j = i + lg
      opt.m[i][j] = Natural.high
      for k in i..<j:
        let cost = opt.m[i][k] + opt.m[k+1][j] + opt.dims[i] * opt.dims[k+1] * opt.dims[j+1]
        if cost < opt.m[i][j]:
          opt.m[i][j] = cost
          opt.s[i][j] = k


proc optimalChainOrder(opt: Optimizer; i, j: Natural): string =
  ## Return the optimal chain order as a string.
  if i == j:
    result.add chr(i + ord('A'))
  else:
    result.add '('
    result.add opt.optimalChainOrder(i, opt.s[i][j])
    result.add opt.optimalChainOrder(opt.s[i][j] + 1, j)
    result.add ')'


when isMainModule:

  const
    Dims1 = @[5, 6, 3, 1]
    Dims2 = @[1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2]
    Dims3 = @[1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10]

  for dims in [Dims1, Dims2, Dims3]:
    var opt = initOptimizer(dims)
    opt.findMatrixChainOrder()
    echo "Dims:  ", dims
    echo "Order: ", opt.optimalChainOrder(0, dims.len - 2)
    echo "Cost:  ", opt.m[0][dims.len - 2]
    echo ""
