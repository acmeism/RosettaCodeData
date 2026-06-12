const Lists = [[9, 3, 3, 3, 2, 1, 7, 8, 5],
               [5, 2, 9, 3, 3, 7, 8, 4, 1],
               [1, 4, 3, 6, 7, 3, 8, 3, 2],
               [1, 2, 3, 4, 5, 6, 7, 8, 9],
               [4, 6, 8, 7, 2, 3, 3, 3, 1]]

func contains3Adjacent3(s: openArray[int]): bool =
  if s.len < 3: return false
  var count = 0
  for i in 0..s.high:
    if s[i] == 3:
      inc count
      if count == 3: return true
    else:
      count = 0


for list in Lists:
  echo list, ": ", list.contains3Adjacent3()
