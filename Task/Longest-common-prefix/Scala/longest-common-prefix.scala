class TestLCP extends FunSuite {
  test("shared start") {
    assert(lcp("interspecies","interstellar","interstate") === "inters")
    assert(lcp("throne","throne") === "throne")
    assert(lcp("throne","dungeon").isEmpty)
    assert(lcp("cheese") === "cheese")
    assert(lcp("").isEmpty)
    assert(lcp(Nil :_*).isEmpty)
    assert(lcp("prefix","suffix").isEmpty)
  }

  def lcp(list: String*) = list.foldLeft("")((_,_) =>
    (list.min.view,list.max.view).zipped.takeWhile(v => v._1 == v._2).unzip._1.mkString)
}
