object Isin extends App {
  val isins = Seq("US0378331005", "US0373831005", "U50378331005",
    "US03378331005", "AU0000XVGZA3","AU0000VXGZA3", "FR0000988040")

  private def ISINtest(isin: String): Boolean = {
    val isin0 = isin.trim.toUpperCase

    def luhnTestS(number: String): Boolean = {

      def luhnTestN(digits: Seq[Int]): Boolean = {

        def checksum(digits: Seq[Int]): Int = {
          digits.reverse.zipWithIndex
            .foldLeft(0) {
              case (sum, (digit, i)) =>
                if (i % 2 == 0) sum + digit
                else sum + (digit * 2) / 10 + (digit * 2) % 10
            } % 10
        }

        checksum(digits) == 0
      }

      luhnTestN(number.map { c =>
        assert(c.isDigit, s"$number has a non-digit error")
        c.asDigit
      })
    }

    if (!isin0.matches("^[A-Z]{2}[A-Z0-9]{9}\\d$")) false
    else {
      val sb = new StringBuilder
      for (c <- isin0.substring(0, 12)) sb.append(Character.digit(c, 36))
      luhnTestS(sb.toString)
    }
  }

  isins.foreach(isin => println(f"$isin is ${if (ISINtest(isin)) "" else "not"}%s valid"))

}
