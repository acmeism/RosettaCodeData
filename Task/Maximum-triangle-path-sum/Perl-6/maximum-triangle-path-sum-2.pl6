sub infix:<op>(@a,@b) { (@a Zmax @a[1..*]) Z+ @b }

say [op] slurp("triangle.txt").lines.reverse.map: { [.words] }
