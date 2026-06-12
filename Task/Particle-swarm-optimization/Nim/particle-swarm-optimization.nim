import math, random, sequtils, sugar

type

  Func = seq[float] -> float

  Parameters = tuple[omega, phip, phig: float]

  State = object
    iter: int
    gbpos: seq[float]
    gbval: float
    min, max: seq[float]
    parameters: Parameters
    pos, vel, bpos: seq[seq[float]]
    bval: seq[float]
    nParticles, nDims: int


func initState(min, max: seq[float]; parameters: Parameters; nParticles: int): State =
  let nDims = min.len
  State(iter: 0,
        gbpos: repeat(Inf, nDims),
        gbval: Inf,
        min: min,
        max: max,
        parameters: parameters,
        pos: repeat(min, nParticles),
        vel: newSeqWith(nParticles,
        newSeq[float](nDims)),
        bpos: repeat(min, nParticles),
        bval: repeat(Inf, nParticles),
        nParticles: nParticles,
        nDims: nDims)


proc report(state: State; testFunc: string) =
  echo "Test Function:        ", testfunc
  echo "Iterations:           ", state.iter
  echo "Global Best Position: ", state.gbpos
  echo "Global Best Value:    ", state.gbval


proc pso(fn: Func; y: State): State =
  let p = y.parameters
  var v = newSeq[float](y.nParticles)
  var bpos  = repeat(y.min, y.nParticles)
  var bval  = newSeq[float](y.nParticles)
  var gbpos = newSeq[float](y.nDims)
  var gbval = Inf

  for j in 0..<y.nParticles:
    # evaluate.
    v[j] = fn(y.pos[j])
    # update.
    if v[j] < y.bval[j]:
      bpos[j] = y.pos[j]
      bval[j] = v[j]
    else:
      bpos[j] = y.bpos[j]
      bval[j] = y.bval[j]
    if bval[j] < gbval:
      gbval = bval[j]
      gbpos = bpos[j]

  let rg = rand(1.0)
  var pos = newSeqWith(y.nParticles, newSeq[float](y.nDims))
  var vel = newSeqWith(y.nParticles, newSeq[float](y.nDims))
  for j in 0..<y.nParticles:
    # migrate.
    let rp = rand(1.0)
    var ok = true
    for k in 0..<y.nDims:
      vel[j][k] = p.omega * y.vel[j][k] +
                  p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                  p.phig * rg * (gbpos[k] - y.pos[j][k])
      pos[j][k] = y.pos[j][k] + vel[j][k]
      ok = ok and y.min[k] < pos[j][k] and y.max[k] > pos[j][k]
    if not ok:
      for k in 0..<y.nDims:
        pos[j][k]= y.min[k] + (y.max[k] - y.min[k]) * rand(1.0)

  result = State(iter: 1 + y.iter,
                 gbpos: gbpos,
                 gbval: gbval,
                 min: y.min,
                 max: y.max,
                 parameters: y.parameters,
                 pos: pos,
                 vel: vel,
                 bpos: bpos,
                 bval: bval,
                 nParticles: y.nParticles,
                 nDims: y.nDims)


proc iterate(fn: Func; n: int; y: State): State =
  result = y
  if n == int.high:
    while true:
      let old = result
      result = pso(fn, result)
      if result == old: break
  else:
    for _ in 1..n:
      result = pso(fn, result)


func mccormick(x: seq[float]): float =
  let a = x[0]
  let b = x[1]
  result = sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a


func michalewicz(x: seq[float]): float =
  const M = 10
  for i in 1..x.len:
    let j = x[i - 1]
    let k = sin(i.toFloat * j * j / PI)
    result -= sin(j) * k^(2 * M)


randomize()

var state = initState(min = @[-1.5, -3],
                      max = @[4.0, 4.0],
                      parameters = (0.0, 0.6, 0.3),
                      nParticles = 100)

state = iterate(mccormick, 40, state)
state.report("McCormick")
echo "f(-.54719, -1.54719): ", mccormick(@[-0.54719, -1.54719])
echo()
state = initState(min = @[0.0, 0.0],
                  max = @[PI, PI],
                  parameters = (0.3, 0.3, 0.3),
                  nParticles = 1000)
state = iterate(michalewicz, 30, state)
state.report("Michalewicz (2D)")
echo "f(2.20, 1.57):        ", michalewicz(@[2.2, 1.57])
