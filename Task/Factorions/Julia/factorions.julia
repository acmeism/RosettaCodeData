isfactorian(n, base) = mapreduce(factorial, +, map(c -> parse(Int, c, base=16), split(string(n, base=base), ""))) == n

printallfactorian(base) = println("Factorians for base $base: ", [n for n in 1:100000 if isfactorian(n, base)])

foreach(printallfactorian, 9:12)
