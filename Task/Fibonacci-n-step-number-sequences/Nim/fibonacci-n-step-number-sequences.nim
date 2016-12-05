import sequtils, strutils

proc fiblike(start: seq[int]): auto =
  var memo = start
  proc fibber(n: int): int =
    if n < memo.len:
      return memo[n]
    else:
      var ans = 0
      for i in n-start.len .. <n:
        ans += fibber(i)
      memo.add ans
      return ans
  return fibber

let fibo = fiblike(@[1,1])
echo toSeq(0..9).map(fibo)
let lucas = fiblike(@[2,1])
echo toSeq(0..9).map(lucas)

for n, name in items({2: "fibo", 3: "tribo", 4: "tetra", 5: "penta", 6: "hexa",
                      7: "hepta", 8: "octo", 9: "nona", 10: "deca"}):
  var se = @[1]
  for i in 0..n-2:
    se.add(1 shl i)
  let fibber = fiblike(se)
  echo "n = ", align($n,2), ", ", align(name, 5), "nacci ->
    ", toSeq(0..14).mapIt(string, $fibber(it)).join(" "), " ..."
