import algorithm, math, strutils

func divisors(n: int): seq[int] =
  var smallDivs = @[1]
  for i in 2..sqrt(n.toFloat).int:
    if n mod i == 0:
      let j = n div i
      smallDivs.add i
      if i != j: result.add j
  result.add reversed(smallDivs)

func abundant(n: int; divs: seq[int]): bool {.inline.}=
  sum(divs) > n

func semiperfect(n: int; divs: seq[int]): bool =
  if divs.len > 0:
    let h = divs[0]
    let t = divs[1..^1]
    result = if n < h: semiperfect(n, t)
             else: n == h or semiperfect(n - h, t) or semiperfect(n, t)

func sieve(limit: int): seq[bool] =
  # False denotes abundant and not semi-perfect.
  # Only interested in even numbers >= 2.
  result.setLen(limit)
  for i in countup(2, limit - 1, 2):
    if result[i]: continue
    let divs = divisors(i)
    if not abundant(i, divs):
      result[i] = true
    elif semiperfect(i, divs):
      for j in countup(i, limit - 1, i):
        result[j] = true


const Max = 25
let w = sieve(17_000)
var list: seq[int]

echo "The first 25 weird numbers are:"
var n = 2
while list.len != Max:
  if not w[n]: list.add n
  inc n, 2
echo list.join(" ")
