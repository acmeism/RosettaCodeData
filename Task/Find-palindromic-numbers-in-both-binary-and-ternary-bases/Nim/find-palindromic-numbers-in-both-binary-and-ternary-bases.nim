import bitops, strformat, times

#---------------------------------------------------------------------------------------------------

func isPal2(k: uint64; digitCount: Natural): bool =
  ## Return true if the "digitCount" + 1 bits of "k" form a palindromic number.

  for i in 0..digitCount:
    if k.testBit(i) != k.testBit(digitCount - i):
      return false
  result = true

#---------------------------------------------------------------------------------------------------

func reverseNumber(k: uint64): uint64 =
  ## Return the reverse number of "n".

  var p = k
  while p > 0:
    result += 2 * result + p mod 3
    p = p div 3

#---------------------------------------------------------------------------------------------------

func toBase2(n: uint64): string =
  ## Return the string representation of "n" in base 2.

  var n = n
  while true:
    result.add(chr(ord('0') + (n and 1)))
    n = n shr 1
    if n == 0: break

#---------------------------------------------------------------------------------------------------

func toBase3(n: uint64): string =
  ## Return the string representation of "n" in base 3.

  var n = n
  while true:
    result.add(chr(ord('0') + n mod 3))
    n = n div 3
    if n == 0: break

#---------------------------------------------------------------------------------------------------

proc print(n: uint64) =
  ## Print the value in bases 10, 2 and 3.

  echo &"{n:>18}   {n.toBase2():^59}   {n.toBase3():^41}"

#---------------------------------------------------------------------------------------------------

proc findPal23() =
  ## Find the seven first palindromic numbers in binary and ternary bases.

  var p3 = 1u64
  var countPal = 1

  print(0)
  for p in 0..31:
    while (3 * p3 + 1) * p3 < 1u64 shl (2 * p):
      p3 *= 3
    let bound = 1u64 shl (2 * p) div (3 * p3)
    for k in max(p3 div 3, bound) .. min(2 * bound, p3 - 1):
      let n = (3 * k + 1) * p3 + reverseNumber(k)
      if isPal2(n, 2 * p):
        print(n)
        inc countPal
        if countPal == 7:
          return

#———————————————————————————————————————————————————————————————————————————————————————————————————

let t0 = cpuTime()
findPal23()
echo fmt"\nTime: {cpuTime() - t0:.2f}s"
