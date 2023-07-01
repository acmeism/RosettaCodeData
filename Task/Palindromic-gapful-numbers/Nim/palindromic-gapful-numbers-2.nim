import strutils  # for number input
import times                 # for timing code execution
import unicode               # for reversed

proc palindromicgapfuls(digit, count, keep: int): seq[uint64] =
  var palcnt = 0                      # count of gapful palindromes
  let to_skip = count - keep          # count of unwanted values to skip
  let nn = digit * 11                 # digit gapful divisor: 11, 22,...88, 99
  var (power, base, digit) = (1, 1u64, digit.uint64)
  while true:
    if (power.inc; power and 1) == 0: base *= 10
    let base11  = base * 11           # value of middle two digits positions: 110..
    let this_lo = base * digit        # starting half for this digit: 10.. to  90..
    let next_lo = base * (digit + 1)  # starting half for next digit: 20.. to 100..
    for front_half in countup(this_lo, next_lo - 2, 10):
      var
        basep = base11
        left_half = $front_half
      let right_half = left_half.reversed
      if (power and 1) == 0: basep = base; left_half.setLen left_half.len - 1
      var palindrome = (left_half.add right_half; left_half).parseUInt.uint64
      for _ in 0..9:
        if palindrome mod nn.uint == 0: (palcnt.inc; if palcnt > to_skip: result.add palindrome)
        palindrome += basep
      if result.len >= keep: result.setLen(keep); return

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
