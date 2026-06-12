import strutils

func shouldSwap(s: string; start, curr: int): bool =
  for i in start..<curr:
    if s[i] == s[curr]: return false
  return true


func findPerms(s: string; index, n: int; res: var seq[string]) =
  if index >= n:
    res.add s
    return
  var s = s
  for i in index..<n:
    if s.shouldSwap(index, i):
      swap s[index], s[i]
      findPerms(s, index+1, n, res)
      swap s[index], s[i]


func createSlice(nums: openArray[int]; charSet: string): string =
  for i, n in nums:
      for _ in 1..n:
        result.add charSet[i]


when isMainModule:
  var res1, res2, res3: seq[string]
  var nums = @[2, 1]

  var s = createSlice(nums, "12")
  s.findPerms(0, s.len, res1)
  echo res1.join(" ")
  echo()

  nums = @[2, 3, 1]
  s = createSlice(nums, "123")
  findPerms(s, 0, s.len, res2)
  for i, val in res2:
    stdout.write val, if (i + 1) mod 10 == 0: '\n' else: ' '
  echo()

  s = createSlice(nums, "ABC")
  findPerms(s, 0, s.len, res3)
  for i, val in res3:
    stdout.write val, if (i + 1) mod 10 == 0: '\n' else: ' '
