scala> val h = new HVar(3)
h: HVar[Int] = HVar(3)

scala> h := 11

scala> h := 90

scala> !h
res32: Int = 90

scala> h.history
res33: List[Int] = List(90, 11, 3)

scala> h.undo
res34: Int = 90

scala> h.undo
res35: Int = 11

scala> h.undo
res36: Int = 3
