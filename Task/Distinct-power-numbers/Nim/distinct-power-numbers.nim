import algorithm, math, sequtils, strutils, sugar

let list = collect(newSeq):
             for a in 2..5:
               for b in 2..5: a^b

echo sorted(list).deduplicate(true).join(" ")
