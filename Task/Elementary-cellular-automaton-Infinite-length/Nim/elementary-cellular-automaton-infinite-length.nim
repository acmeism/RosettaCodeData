import strutils


func step(cells: string; rule: int): string =
  for i in 0..(cells.len - 3):
    var bin = 0
    var b = 2
    for n in i..(i + 2):
      inc bin, ord(cells[n] == '*') shl b
      b = b shr 1
    let a = if (rule and 1 shl bin) != 0: '*' else: '.'
    result.add(a)


func addNoCells(cells: var string) =
  let left = if cells[0] == '*': "." else: "*"
  let right = if cells[^1] == '*': "." else: "*"
  cells.insert(left)
  cells.add(right)
  cells.insert(left)
  cells.add(right)


proc evolve(limit, rule: int) =
  echo "Rule #", rule
  var cells = "*"
  for _ in 0..<limit:
    cells.addNoCells()
    let width = 40 + cells.len shr 1
    echo cells.align(width)
    cells = cells.step(rule)


evolve(35, 90)
