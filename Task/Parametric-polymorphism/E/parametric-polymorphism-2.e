? def t := makeTree(int, 0, null, null)
# value: <tree>

? t :Tree[String]
# problem: Tree value type mismatch

? t :Tree[Int]
# problem: Failed: Undefined variable: Int

? t :Tree[int]
# value: <tree>
