import sugar, strutils

let result = collect(newSeq):
               for n in 1..<1000:
                 if count($n, '1') == 2: n
echo "Found ", result.len, " numbers:"
echo result.join(" ")
