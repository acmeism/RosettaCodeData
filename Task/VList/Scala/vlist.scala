object VList extends App {

  val emptyVlist1 = Vector.empty[Int]
  val emptyVlist2 = Vector[Int]()
  val emptyVlist3 = Vector()

  val addedVlist1 = Vector(1, 2) :+ 6 :+ 10 :+ 12 :+ 42

  assert((addedVlist1, addedVlist1.head) == (Vector(1, 2, 6, 10, 12, 42), 1), "Header or VList not OK")

  val addedVlist2 = addedVlist1.head +: addedVlist1.tail.drop(1)
  assert((addedVlist2, addedVlist2.head) == (Vector(1, 6, 10, 12, 42), 1), "First CDR not deleted.")

  assert(addedVlist1.size == 6)

  assert(addedVlist1(3) == 10, "Wrong element accesed.")
  println("Successfully completed without errors.")
}
