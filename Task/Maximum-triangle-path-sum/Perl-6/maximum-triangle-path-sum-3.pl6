sub infix:<op>(@a,@b) is assoc('right') { @a Z+ (@b Zmax @b[1..*]) }

say [op] slurp("triangle.txt").lines.map: { [.words] }
