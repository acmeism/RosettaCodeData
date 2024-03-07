import java.text.MessageFormat

object CanonicalizeCIDR extends App {
  case class CIDR(address: Int, maskLength: Int) {
    override def toString: String = {
      val a = (address >> 24) & 0xFF
      val b = (address >> 16) & 0xFF
      val c = (address >> 8) & 0xFF
      val d = address & 0xFF
      MessageFormat.format(CIDR.format, a.asInstanceOf[AnyRef], b.asInstanceOf[AnyRef], c.asInstanceOf[AnyRef], d.asInstanceOf[AnyRef], maskLength.asInstanceOf[AnyRef])
    }
  }

  object CIDR {
    private val format = "{0,number,integer}.{1,number,integer}.{2,number,integer}.{3,number,integer}/{4,number,integer}"

    def apply(str: String): CIDR = {
      val args = new MessageFormat(format).parse(str)
      val address = args.take(4).foldLeft(0) { (acc, arg) =>
        val a = arg.asInstanceOf[Number].intValue()
        require(a >= 0 && a <= 255, "Invalid IP address")
        (acc << 8) + a
      }
      val maskLength = args(4).asInstanceOf[Number].intValue()
      require(maskLength >= 1 && maskLength <= 32, "Invalid mask length")
      val mask = ~((1 << (32 - maskLength)) - 1)
      new CIDR(address & mask, maskLength)
    }
  }

  val tests = Array(
    "87.70.141.1/22",
    "36.18.154.103/12",
    "62.62.197.11/29",
    "67.137.119.181/4",
    "161.214.74.21/24",
    "184.232.176.184/18"
  )

  tests.foreach { test =>
    try {
      val cidr = CIDR(test)
      println(f"$test%-18s -> $cidr")
    } catch {
      case ex: Exception => println(s"Error parsing '$test': ${ex.getLocalizedMessage}")
    }
  }
}
