import strutils, sugar

const Lim = 99_999

type Digit = 0..15

func digitSet(n: Natural; b: Positive): set[Digit] =
  ## Return the set of digits of "n" written in base "b".
  assert b <= 16
  if n == 0: return {Digit 0}
  var n = n
  while n != 0:
    result.incl n mod b
    n = n div b

# Build the list of numbers.
let list = collect(newSeq):
             for n in 0..Lim:
               if n.digitSet(10) == n.digitSet(16): n

# Display result.
echo "Found $1 numbers less than $2:".format(list.len, insertSep($(Lim + 1)))
for i, n in list:
  stdout.write ($n).align(5), if (i + 1) mod 10 == 0: '\n' else: ' '
echo()
