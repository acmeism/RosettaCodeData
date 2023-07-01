import times

proc make_palindrome(front_half: uint64, power: int): uint64 =
  var res, front_half = front_half
  if (power and 1) == 0: res = res div 10
  while front_half > 0:
    res = res * 10 + front_half mod 10
    front_half = front_half div 10
  res

proc palindromicgapfuls(digit, count, keep: int): seq[uint64] =
  var (palcnt, digit) = (0, digit.uint64) # count of gapful palindromes
  let to_skip = count - keep            # count of unwanted values to skip
  var gapfuls = newSeq[uint64]()        # array of palindromic gapfuls
  let dd = digit * 11                   # digit gapful divisor: 11, 22,...88, 99
  var (power, base) = (1, 1u64)
  while true:
    if (power.inc; power and 1) == 0: base = base * 10
    var base11  = base * 11             # value of middle two digits positions: 110..
    var this_lo = base * digit          # starting half for this digit: 10.. to  90..
    var next_lo = base * (digit + 1)    # starting half for next digit: 20.. to 100..
    for front_half in countup(this_lo, next_lo - 2, 10):
      let basep = if (power and 1) == 1: base11 else: base
      var palindrome = make_palindrome(front_half, power)
      for _ in 0..9:
        if palindrome mod dd == 0: (palcnt.inc; if palcnt > to_skip: gapfuls.add(palindrome))
        palindrome += basep
      if gapfuls.len >= keep: return gapfuls[0..keep-1]

let start = epochTime()

var (count, keep) = (20, 20)
echo("First 20 palindromic gapful numbers ending with:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

(count, keep) = (100, 15)
echo("\nLast 15 of first 100 palindromic gapful numbers ending in:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

(count, keep) = (1_000, 10)
echo("\nLast 10 of first 1000 palindromic gapful numbers ending in:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

(count, keep) = (100_000, 1)
echo("\n100,000th palindromic gapful number ending with:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

(count, keep) = (1_000_000, 1)
echo("\n1,000,000th palindromic gapful number ending with:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

(count, keep) = (10_000_000, 1)
echo("\n10,000,000th palindromic gapful number ending with:")
for digit in 1..9: echo(digit, " : ", palindromicgapfuls(digit, count, keep) )

echo (epochTime() - start)
