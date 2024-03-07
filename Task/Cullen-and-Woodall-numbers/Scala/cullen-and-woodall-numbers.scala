import java.math.BigInteger
import scala.annotation.tailrec

object CullenAndWoodhall extends App {

  val Certainty = 20
  var number: BigInteger = _
  var power: BigInteger = _
  var count: Int = _
  var primeIndex: Int = _

  sealed trait NumberType
  case object Cullen extends NumberType
  case object Woodhall extends NumberType

  numberSequence(20, Cullen)
  numberSequence(20, Woodhall)
  primeSequence(5, Cullen)
  primeSequence(12, Woodhall)

  def numberSequence(aCount: Int, aNumberType: NumberType): Unit = {
  println(s"\nThe first $aCount $aNumberType numbers are:")
  numberInitialise()
  (1 to aCount).foreach { _ =>
    print(nextNumber(aNumberType).toString + " ")
  }
  println()
}


  def primeSequence(aCount: Int, aNumberType: NumberType): Unit = {
    println(s"\nThe indexes of the first $aCount $aNumberType primes are:")
    primeInitialise()

    @tailrec
    def findPrimes(): Unit = {
      if (count < aCount) {
        if (nextNumber(aNumberType).isProbablePrime(Certainty)) {
          print(primeIndex + " ")
          count += 1
        }
        primeIndex += 1
        findPrimes()
      }
    }

    findPrimes()
    println()
  }

  def nextNumber(aNumberType: NumberType): BigInteger = {
    number = number.add(BigInteger.ONE)
    power = power.shiftLeft(1)
    aNumberType match {
      case Cullen => number.multiply(power).add(BigInteger.ONE)
      case Woodhall => number.multiply(power).subtract(BigInteger.ONE)
    }
  }

  def numberInitialise(): Unit = {
    number = BigInteger.ZERO
    power = BigInteger.ONE
  }

  def primeInitialise(): Unit = {
    count = 0
    primeIndex = 1
    numberInitialise()
  }
}
