import algorithm, strutils, sugar

proc printTable(a: seq[seq[string]]) =
  for row in a:
    for x in row: stdout.write x, repeat(' ', 4 - x.len)
    echo ""
  echo ""

proc sortTable(a: seq[seq[string]], column = 0, reverse = false,
    ordering: (proc(a,b: string): int) = system.cmp) : seq[seq[string]] =
  let order = if reverse: Descending else: Ascending
  result = a
  result.sort(proc(x,y:seq[string]):int = ordering(x[column],y[column]), order)

const data = @[@["a", "b", "c"], @["", "q", "z"], @["zap", "zip", "Zot"]]

printTable data
printTable sortTable(data)
printTable sortTable(data, column = 2)
printTable sortTable(data, column = 1)
printTable sortTable(data, column = 1, reverse = true)
printTable sortTable(data, ordering = (a,b) => cmp[int](b.len,a.len))
