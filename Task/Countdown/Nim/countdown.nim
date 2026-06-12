import std/[os, strutils, tables]

type
  Operator = enum opAdd = "+", opSub = "-", opMul = "×", opDiv = "/", opNone = ""
  Operation = tuple[op1, op2: int; op: Operator; r: int]


func result(values: seq[int]; target: int): tuple[val: int; ops: seq[Operation]] =

  type Results = Table[seq[int], seq[Operation]]

  var results: Results
  results[values] = @[]
  var terminated = false
  while not terminated:
    terminated = true
    var next: Results
    for vals, ops in results:
      var v1 = vals
      for i1, val1 in vals:
        v1.delete i1
        var v2 = v1
        for i2, val2 in v1:
          v2.delete i2
          for op in opAdd..opNone:
            let newVal = case op
                         of opAdd: val1 + val2
                         of opSub: (if val1 > val2: val1 - val2 else: 0)
                         of opMul: val1 * val2
                         of opDiv: (if val1 mod val2 == 0: val1 div val2 else: 0)
                         of opNone: val1
            if newVal > 0:
              v2.add newVal
              if v2.len > 1: terminated = false
              let newOps = if op != opNone: ops & (val1, val2, op, newVal) else: ops
              if v2 notin next or newOps.len < next[v2].len:
                next[v2] = newOps
              discard v2.pop
          v2 = v1
        v1 = vals
    results = move next

  var best = int.high
  var bestOps: seq[Operation]
  for vals, ops in results:
    let val = vals[0]
    if val == target: return (val, ops)
    if abs(val - target) < abs(best - target):
      best = val
      bestOps = ops
  result = (best, bestOps)

let params = commandLineParams()
if params.len != 7:
  quit "Six values + the target value are expected.", QuitFailure
var values: seq[int]
for param in params:
  var val: int
  try:
    val = parseInt(param)
    if val <= 0:
      raise newException(ValueError, "")
  except ValueError:
    quit "Wrong value: " & param, QuitFailure
  values.add val

let target = values.pop()
let (val, ops) = result(values, target)
echo "Target value: ", target
echo "Nearest value computed: ", val
echo "Operations:"
for (op1, op2, op, r) in ops:
  echo "  ", op1, " ", op, " ", op2, " = ", r
