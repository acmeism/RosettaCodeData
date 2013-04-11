trait DFA {
  type Element
  val map = new collection.mutable.HashMap[Element, DFA]()
}
