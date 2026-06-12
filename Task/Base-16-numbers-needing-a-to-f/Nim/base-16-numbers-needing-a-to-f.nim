import strutils, sugar

let list = collect(newSeq):
             for n in 0..500:
               if not n.toHex.allCharsInSet(Digits): n

echo "Found ", list.len, " numbers between 0 and 500:\n"
for i, n in list:
  stdout.write ($n).align(3), if (i + 1) mod 19 == 0: '\n' else: ' '
echo()
