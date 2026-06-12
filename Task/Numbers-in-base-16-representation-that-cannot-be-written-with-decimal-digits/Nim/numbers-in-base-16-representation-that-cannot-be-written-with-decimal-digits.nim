import strutils, sugar

let list = collect(newSeq):
             for d1 in {0, 10..15}:
               for d2 in {10..15}:
                 if (let n = 16 * d1 + d2; n < 500): n

echo "Found ", list.len, " numbers < 500 which cannot be written in base 16 with decimal digits:"
for i, n in list:
  stdout.write ($n).align(3), if (i + 1) mod 7 == 0: '\n' else: ' '
