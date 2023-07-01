proc lcs(x, y: string): string =
  if x.len == 0 or y.len == 0: return
  let x1 = x[0..^2]
  let y1 = y[0..^2]
  if x[^1] == y[^1]: return lcs(x1, y1) & x[^1]
  let x2 = lcs(x, y1)
  let y2 = lcs(x1, y)
  result = if x2.len > y2.len: x2 else: y2

proc scs(u, v: string): string =
  let lcs = lcs(u, v)
  var ui, vi = 0
  for ch in lcs:
    while ui < u.len and u[ui] != ch:
      result.add u[ui]
      inc ui
    while vi < v.len and v[vi] != ch:
      result.add v[vi]
      inc vi
    result.add ch
    inc ui
    inc vi
  if ui < u.len: result.add u.substr(ui)
  if vi < v.len: result.add v.substr(vi)

when isMainModule:
  let u = "abcbdab"
  let v = "bdcaba"
  echo scs(u, v)
