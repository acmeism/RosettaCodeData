for i 99 1 -1 [
     x: rejoin [
         i b: " bottles of beer" o: " on the wall. " i b
         ". Take one down, pass it around. " (i - 1) b o "^/"
     ]
     r: :replace j: "bottles" k: "bottle"
     switch i [1 [r x j k r at x 10 j k r x "0" "No"] 2 [r at x 40 j k]]
     print x
] halt
