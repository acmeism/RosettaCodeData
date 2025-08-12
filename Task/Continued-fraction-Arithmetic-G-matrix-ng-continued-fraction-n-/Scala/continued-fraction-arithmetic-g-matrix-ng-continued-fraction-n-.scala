trait IteratorTrait {
  def hasNext: Boolean
  def next: Int
}

class CFData(val text: String, val args: Array[Int], val iterator: IteratorTrait)

class R2cfIterator(var numerator: Int, var denominator: Int) extends IteratorTrait {
  def hasNext: Boolean = denominator != 0

  def next: Int = {
    val div = numerator / denominator
    val rem = numerator % denominator
    numerator = denominator
    denominator = rem
    div
  }
}

class Root2 extends IteratorTrait {
  private var firstReturn = true

  def hasNext: Boolean = true

  def next: Int = {
    if (firstReturn) {
      firstReturn = false
      1
    } else {
      2
    }
  }
}

class ReciprocalRoot2 extends IteratorTrait {
  private var firstReturn = true
  private var secondReturn = true

  def hasNext: Boolean = true

  def next: Int = {
    if (firstReturn) {
      firstReturn = false
      0
    } else if (secondReturn) {
      secondReturn = false
      1
    } else {
      2
    }
  }
}

class NG(val args: Array[Int]) {
  private var a1: Int = args(0)
  private var a: Int = args(1)
  private var b1: Int = args(2)
  private var b: Int = args(3)

  def ingress(aN: Int): Unit = {
    val temp = a
    a = a1
    a1 = temp + a1 * aN
    val tempB = b
    b = b1
    b1 = tempB + b1 * aN
  }

  def egress: Int = {
    val n = a / b
    val temp = a
    a = b
    b = temp - b * n
    val tempA1 = a1
    a1 = b1
    b1 = tempA1 - b1 * n
    n
  }

  def needsTerm: Boolean = b == 0 || b1 == 0 || a * b1 != a1 * b

  def egressDone: Int = {
    if (needsTerm) {
      a = a1
      b = b1
    }
    egress
  }

  def done: Boolean = b == 0 || b1 == 0
}

object ContinuedFractionArithmeticG1 {
  def main(args: Array[String]): Unit = {
    val cfData = Array(
      new CFData("[1; 5, 2] + 1 / 2", Array(2, 1, 0, 2), new R2cfIterator(13, 11)),
      new CFData("[3; 7] + 1 / 2", Array(2, 1, 0, 2), new R2cfIterator(22, 7)),
      new CFData("[3; 7] divided by 4", Array(1, 0, 0, 4), new R2cfIterator(22, 7)),
      new CFData("sqrt(2)", Array(0, 1, 1, 0), new Root2),
      new CFData("1 / sqrt(2)", Array(0, 1, 1, 0), new ReciprocalRoot2),
      new CFData("(1 + sqrt(2)) / 2", Array(1, 1, 0, 2), new Root2),
      new CFData("(1 + 1 / sqrt(2)) / 2", Array(1, 1, 0, 2), new ReciprocalRoot2)
    )

    for (data <- cfData) {
      print(s"${data.text} -> ")
      val ng = new NG(data.args)
      val iterator = data.iterator
      var nextTerm = 0
      for (i <- 1 to 20 if iterator.hasNext) {
        nextTerm = iterator.next
        if (!ng.needsTerm) {
          print(s"${ng.egress} ")
        }
        ng.ingress(nextTerm)
      }
      while (!ng.done) {
        print(s"${ng.egressDone} ")
      }
      println()
    }
  }
}
