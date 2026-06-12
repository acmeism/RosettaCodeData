var a: array[17, array[17, int]]
var idx: array[4, int]


proc findGroup(kind, minN, maxN, depth: int): bool =

  if depth == 4:
    echo "\nTotally ", if kind != 0: "" else: "un", "connected group:"
    for i in 0..3:
      stdout.write idx[i], if i == 3: '\n' else: ' '
    return true

  for i in minN..<maxN:
    var n = depth
    for m in 0..<depth:
      if a[idx[m]][i] != kind:
        n = m
        break
    if n == depth:
      idx[n] = i
      if findGroup(kind, 1, maxN, depth + 1):
        return true


for i in 0..16: a[i][i] = 2
var j: int
var k = 1
while k <= 8:
  for i in 0..16:
    j = (i + k) mod 17
    a[i][j] = 1
    a[j][i] = 1
  k = k shl 1

const Mark = "01-"
for i in 0..16:
  for m in 0..16:
    stdout.write Mark[a[i][m]], if m == 16: '\n' else: ' '

for i in 0..16:
  idx[0] = i
  if findGroup(1, i + 1, 17, 1) or findGroup(0, i + 1, 17, 1):
    quit "\nRamsey condition not satisfied.", QuitFailure

echo "\nRamsey condition satisfied."
