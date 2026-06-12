import fenv, lists, math, sequtils, strformat, strutils

type

  Shipment = object
    quantity: float
    costPerUnit: float
    r, c: int

  Transport = object
    filename: string
    supply: seq[int]
    demand: seq[int]
    costs: seq[seq[float]]
    matrix: seq[seq[Shipment]]

  ShipmentList = DoublyLinkedList[Shipment]

const ShipZero = Shipment()


template emitError(msg: string) =
  raise newException(ValueError, msg)


proc initTransport(filename: string): Transport =
  let infile = filename.open()
  let fields = infile.readLine().splitWhitespace().map(parseInt)
  let numSources = fields[0]
  let numDests = fields[1]
  if numSources < 1 or numDests < 1:
    emitError "wrong number of sources or destinations."
  var src = infile.readLine().splitWhitespace().map(parseInt)
  if src.len != numSources:
    emitError "wrong number of sources; got $1, expected $2.".format(src.len, numSources)
  var dst = infile.readLine().splitWhitespace().map(parseInt)
  if dst.len != numDests:
    emitError "wrong number of destinations; got $1, expected $2.".format(dst.len, numDests)

  # Fix imbalance.
  let totalSrc = sum(src)
  let totalDst = sum(dst)
  let diff = totalSrc - totalDst
  if diff > 0: dst.add diff
  elif diff < 0: src.add -diff

  var costs = newSeqWith(src.len, newSeq[float](dst.len))
  var matrix = newSeqWith(src.len, newSeq[Shipment](dst.len))

  for i in 0..<numSources:
    let fields = infile.readLine().splitWhitespace().map(parseFloat)
    if fields.len > dst.len:
      emitError "wrong number of costs; got $1, expected $2.".format(fields.len, numDests)
    for j in 0..<numDests:
      costs[i][j] = fields[j]

  result = Transport(filename: filename, supply: move(src),
                     demand: move(dst), costs: move(costs), matrix: move(matrix))


func northWestCornerRule(tr: var Transport) =
  var northWest = 0
  for r in 0..tr.supply.high:
    for c in northWest..tr.demand.high:
      let quantity = min(tr.supply[r], tr.demand[c])
      if quantity > 0:
        tr.matrix[r][c] = Shipment(quantity: quantity.toFloat, costPerUnit: tr.costs[r][c], r: r, c: c)
        dec tr.supply[r], quantity
        dec tr.demand[c], quantity
        if tr.supply[r] == 0:
          northWest = c
          break


func getNeighbors(tr: Transport; s: Shipment; list: ShipmentList): array[2, Shipment] =
  for o in list:
    if o != s:
      if o.r == s.r and result[0] == ShipZero:
        result[0] = o
      elif o.c == s.c and result[1] == ShipZero:
        result[1] = o
      if result[0] != ShipZero and result[1] != ShipZero:
        break


func matrixToList(tr: Transport): ShipmentList =
  for m in tr.matrix:
    for s in m:
      if s != ShipZero:
        result.append(s)


func getClosedPath(tr: Transport; s: Shipment): seq[Shipment] =
  var path = tr.matrixToList
  path.prepend(s)

  # Remove (and keep removing) elements that do not have a
  # vertical and horizontal neighbor.
  while true:
    var removals = 0
    for e in path.nodes:
      let nbrs = tr.getNeighbors(e.value, path)
      if nbrs[0] == ShipZero or nbrs[1] == ShipZero:
        path.remove(e)
        inc removals
    if removals == 0:
      break

  # Place the remaining elements in the correct plus-minus order.
  var prev = s
  var i = 0
  for _ in path:
    result.add prev
    prev = tr.getNeighbors(prev, path)[i]
    i = 1 - i


func fixDegenerateCase(tr: var Transport) =
  const Eps = minimumPositiveValue(float)
  if tr.supply.len + tr.demand.len - 1 != tr.matrix.len * tr.matrix[0].len:
    for r in 0..tr.supply.high:
      for c in 0..tr.demand.high:
        if tr.matrix[r][c] == ShipZero:
          let dummy = Shipment(quantity: Eps, costPerUnit: tr.costs[r][c], r: r, c: c)
          if tr.getClosedPath(dummy).len == 0:
            tr.matrix[r][c] = dummy
            return


func steppingStone(tr: var Transport) =
  var maxReduction = 0.0
  var move: seq[Shipment]
  var leaving = ShipZero
  tr.fixDegenerateCase()

  for r in 0..tr.supply.high:
    for c in 0..tr.demand.high:
      if tr.matrix[r][c] != ShipZero:
        continue
      let trial = Shipment(quantity: 0, costPerUnit: tr.costs[r][c], r: r, c: c)
      var path = tr.getClosedPath(trial)
      var reduction = 0.0
      var lowestQuantity = float(int32.high)
      var leavingCandidate = ShipZero
      var plus = true
      for s in path:
        if plus:
          reduction += s.costPerUnit
        else:
          reduction -= s.costPerUnit
          if s.quantity < lowestQuantity:
            leavingCandidate = s
            lowestQuantity = s.quantity
        plus = not plus
      if reduction < maxReduction:
        move = move(path)
        leaving = leavingCandidate
        maxReduction = reduction

  if move.len != 0:
    let q = leaving.quantity
    var plus = true
    for s in move.mitems:
      if plus: s.quantity += q
      else: s.quantity -= q
      tr.matrix[s.r][s.c] = if s.quantity == 0: ShipZero else: s
      plus = not plus
    tr.steppingStone()


proc printResult(tr: Transport) =
  echo tr.filename, '\n'
  stdout.write tr.filename.readFile()
  echo "\nOptimal solution for ", tr.filename, '\n'
  var totalCosts = 0.0
  for r in 0..tr.supply.high:
    for c in 0..tr.demand.high:
      let s = tr.matrix[r][c]
      if s != ShipZero and s.r == r and s.c == c:
        stdout.write &" {int(s.quantity):3} "
        totalCosts += s.quantity * s.costPerUnit
      else:
        stdout.write "  -  "
    echo()
  echo &"\nTotal costs: {totalCosts:g}\n"


when isMainModule:

  const Filenames = ["input1.txt", "input2.txt", "input3.txt"]
  for filename in Filenames:
    var tr = initTransport(filename)
    tr.northWestCornerRule()
    tr.steppingStone()
    tr.printResult()
