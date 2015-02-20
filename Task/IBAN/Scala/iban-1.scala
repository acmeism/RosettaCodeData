import scala.collection.immutable.SortedMap

class Iban(val iban: String) {
  // Isolated tests
  def isAllUpperCase = iban.toUpperCase == iban

  def isValidpattern = (Iban.pattern findFirstIn iban).nonEmpty

  def isNationalSize = {
    Iban.ccVsLength.getOrElse(iban.take(2), 0) == iban.size
  }

  def isCheckNumberOK = {
    def rearrange = (iban.drop(4) + iban.take(4)). // Move left country code part to end
      // continue with each char converted to Int
      map(ch => if (ch.isDigit) ch.toInt - '0' else ch - 'A' + 10).mkString

    (BigInt(rearrange) mod 97) == 1
  }

  def isValidIban = {
    isAllUpperCase &&
      isValidpattern &&
      isNationalSize &&
      isCheckNumberOK
  }
}

object Iban {
  // IBAN length database
  lazy val ccVsLength: SortedMap[String, Int] = SortedMap[String, Int]() ++
    """AD24 AE23 AL28 AO25 AT20 AZ28 BA20 BE16 BF27 BG22 BH22 BI16
      |BJ28 BR29 CG27 CH21 CI28 CM27 CR21 CV25 CY28 CZ24 DE22 DK18
      |DO28 DZ24 EE20 EG27 ES24 FI18 FO18 FR27 GA27 GB22 GE22 GI23
      |GL18 GR27 GT28 HR21 HU28 IE22 IL23 IR26 IS26 IT27 JO30 KW30
      |KZ20 LB28 LI21 LT20 LU20 LV21 MC27 MD24 ME22 MG27 MK19 ML28
      |MR27 MT31 MU30 MZ25 NL18 NO15 PK24 PL28 PS29 PT25 QA29 RO24
      |RS22 SA24 SE24 SI19 SK24 SM27 SN28 TN24 TR26 UA29 VG24""".
      stripMargin.replaceAll( """\s""", " ").split(' ').
      map(v => (v.take(2), if (v.isEmpty) 0 else v.slice(2, 4).toInt))

  lazy val pattern = "([A-Z]{2})([0-9]{2})([A-Z0-9]{4})([A-Z0-9]{0,2})([0-9]{7})(([A-Z0-9]?){0,16})".r

  def apply(s: String) = new Iban(s.replaceAll( """\s""", ""))
}
