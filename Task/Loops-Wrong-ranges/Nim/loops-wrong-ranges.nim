import sequtils, strformat

proc displayRange(first, last, step: int) =

  stdout.write &"({first:>2}, {last:>2}, {step:>2}):   "

  echo if step > 0: ($toSeq(countup(first, last, step)))[1..^1]
       elif step < 0: ($toSeq(countdown(first, last, -step)))[1..^1]
       else: "not allowed."

for (f, l, s) in [(-2, 2, 1), (-2, 2, 0), (-2, 2, -1),
                  (-2, 2, 10), (2, -2, 1), (2, 2, 1),
                  (2, 2, -1), (2, 2, 0), (0, 0, 0)]:
  displayRange(f, l, s)
