import strutils  # for number input
import times                 # for timing code execution
import unicode               # for reversed

proc palindromicgapfuls(digit, count, keep: int): seq[uint64] =
  var palcnt = 0                        # count of gapful palindromes
  let to_skip = count - keep            # count of unwanted values to skip
  var gapfuls = newSeq[uint64]()        # array of palindromic gapfuls
  let nn = digit * 11                   # digit gapful divisor: 11, 22,...88, 99
  var (power, base, basep) = (1, 1, 0)
  while true:
    if (power.inc; power and 1) == 0: base = base * 10
    var base11  = base * 11             # value of middle two digits positions: 110..
    var this_lo = base * digit          # starting half for this digit: 10.. to  90..
    var next_lo = base * (digit + 1)    # starting half for next digit: 20.. to 100..
    while this_lo < next_lo - 1:
      var (palindrome, palindrome_base, left_half) = (0'u64, 0'u64, this_lo.intToStr)
      let right_half = left_half.reversed
      if (power and 1) == 1: basep = base11; palindrome_base = (left_half & right_half).parseUInt
      else: basep = base; left_half.removeSuffix("0"); palindrome_base = (left_half & right_half).parseUInt
      for i in 0..9:
        palindrome = palindrome_base + (basep * i).uint
        if (palindrome mod nn.uint) == 0:
          if palcnt < to_skip: (palcnt += 1; continue)
          gapfuls.add(palindrome)
          if gapfuls.len == keep: return gapfuls
      this_lo += 10

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
