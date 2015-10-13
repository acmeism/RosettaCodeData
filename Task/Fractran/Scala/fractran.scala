class TestFractran extends FunSuite {
  val program = Fractran("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1")
  val expect = List(2, 15, 825, 725, 1925, 2275, 425, 390, 330, 290, 770, 910, 170, 156, 132)

  test("find first fifteen fractran figures") {
    assert((program .execute(2) take 15 toList) === expect)
  }
}

object Fractran {
  val pattern = """\s*(\d+)\s*/\s*(\d+)\s*""".r
  def parse(m: Match) = ((m group 1).toInt, (m group 2).toInt)
  def apply(program: String) =  new Fractran(
    pattern.findAllMatchIn(program).map(parse).toList)
}

class Fractran(val numDem: List[(Int,Int)]) {
  def execute(value: Int) = unfold(value) { v =>
    numDem indexWhere(v % _._2 == 0) match {
      case i if i > -1 => Some(v, numDem(i)._1 * v / numDem(i)._2)
      case _ => None
    }
  }
}
