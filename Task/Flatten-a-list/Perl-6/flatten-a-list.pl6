multi flatten (@a) { map { flatten $^x }, @a }
multi flatten ($x) { $x }
