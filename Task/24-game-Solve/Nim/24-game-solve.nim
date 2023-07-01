import algorithm, sequtils, strformat

type
  Operation = enum
    opAdd = "+"
    opSub = "-"
    opMul = "*"
    opDiv = "/"

const Ops = @[opAdd, opSub, opMul, opDiv]

func opr(o: Operation, a, b: float): float =
  case o
  of opAdd: a + b
  of opSub: a - b
  of opMul: a * b
  of opDiv: a / b

func solve(nums: array[4, int]): string =
  func `~=`(a, b: float): bool =
    abs(a - b) <= 1e-5

  result = "not found"
  let sortedNums = nums.sorted.mapIt float it
  for i in product Ops.repeat 3:
    let (x, y, z) = (i[0], i[1], i[2])
    var nums = sortedNums
    while true:
      let (a, b, c, d) = (nums[0], nums[1], nums[2], nums[3])
      if x.opr(y.opr(a, b), z.opr(c, d)) ~= 24.0:
        return fmt"({a:0} {y} {b:0}) {x} ({c:0} {z} {d:0})"
      if x.opr(a, y.opr(b, z.opr(c, d))) ~= 24.0:
        return fmt"{a:0} {x} ({b:0} {y} ({c:0} {z} {d:0}))"
      if x.opr(y.opr(z.opr(c, d), b), a) ~= 24.0:
        return fmt"(({c:0} {z} {d:0}) {y} {b:0}) {x} {a:0}"
      if x.opr(y.opr(b, z.opr(c, d)), a) ~= 24.0:
        return fmt"({b:0} {y} ({c:0} {z} {d:0})) {x} {a:0}"
      if not nextPermutation(nums): break

proc main() =
  for nums in [
               [9, 4, 4, 5],
               [1, 7, 2, 7],
               [5, 7, 5, 4],
               [1, 4, 6, 6],
               [2, 3, 7, 3],
               [8, 7, 9, 7],
               [1, 6, 2, 6],
               [7, 9, 4, 1],
               [6, 4, 2, 2],
               [5, 7, 9, 7],
               [3, 3, 8, 8], # Difficult case requiring precise division
              ]:
    echo fmt"solve({nums}) -> {solve(nums)}"

when isMainModule: main()
