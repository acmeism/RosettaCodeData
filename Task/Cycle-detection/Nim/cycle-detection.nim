import strutils, sugar


func brent(f: int -> int; x0: int): (int, int) =

  # Main phase: search successive powers of two.
  var
    power, λ = 1
    tortoise = x0
    hare = f(x0)

  while tortoise != hare:
    if power == λ:
      # Time to start a new power of two.
      tortoise = hare
      power *= 2
      λ = 0
    hare = f(hare)
    inc λ

  # Find the position of the first repetition of length λ.
  tortoise = x0
  hare = x0
  for i in 0..<λ:
    hare = f(hare)
  # The distance between the hare and tortoise is now λ.

  # Next, the hare and tortoise move at same speed until they agree.
  var μ = 0
  while tortoise != hare:
    tortoise = f(tortoise)
    hare = f(hare)
    inc μ

  result = (λ, μ)


when isMainModule:

  func f(x: int): int = (x * x + 1) mod 255

  let x0 = 3
  let (λ, μ) = brent(f, x0)
  echo "Cycle length: ", λ
  echo "Cycle start index: ", μ
  var cycle: seq[int]
  var x = x0
  for i in 0..<λ+μ:
    if i >= μ: cycle.add x
    x = f(x)
  echo "Cycle: ", cycle.join(" ")
