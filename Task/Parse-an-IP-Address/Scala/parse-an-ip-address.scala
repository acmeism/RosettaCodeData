object IPparser extends App {

  /*
  Parse an IP (v4/v6) Address

  This software can parse all ipv4/ipv6 address text representations
  of IP Address in common usage against the IEF RFC 5952 specification.

  The results of the parse are:
  - The parts of the text are valid representations. This is indicated in the list by a ✔ or ✘.
  - The intended version; 4 or 6.
  - Compliance with RFC 5952 in respect with double colons Compressed zeroes expansion ('::') and lower case letters.
  - Hexadecimal representation of the intended IP address.
  - If part in the text the port number which is optional.
  - The used text string search pattern.

  As much of the information is produced if there are invalid parts in the remark field.
  */

  def myCases = Map(
    "http:"                                      -> IPInvalidAddressComponents(remark = "No match at all: 'http:'."),
    "http://"                                    -> IPInvalidAddressComponents(remark = "No match at all: 'http://'."),
    "http:// "                                   -> IPInvalidAddressComponents(remark = "No match at all: 'http:// '."),
    "http://127.0.0.1/"                          -> ResultContainer(4, BigInt("7F000001", 16)),
    "http://127.0.0.1:80/"                       -> ResultContainer(4, BigInt("7F000001", 16), Some(80)),
    "http://127.0.0.1:65536" ->
      IPInvalidAddressComponents(4, BigInt("7F000001", 16), Some(65536), remark = "Port number out of range."),
    "http://192.168.0.1"                         -> ResultContainer(4, BigInt("C0A80001", 16)),
    "http:/1::"                                  -> ResultContainer(6, BigInt("10000000000000000000000000000", 16)),
    "http:/2001:0db8:0:0:0:0:1428:57ab/"         -> ResultContainer(6, BigInt("20010db80000000000000000142857ab", 16)),
    "2001:0db8:0:0:8d3:0:0:0"                    -> ResultContainer(6, BigInt("20010db80000000008d3000000000000", 16)),
    "2001:db8:0:0:8d3::"                         -> ResultContainer(6, BigInt("20010db80000000008d3000000000000", 16)),
    "http:/2001:db8:3:4::192.0.2.33"                   -> ResultContainer(6, BigInt("20010db80003000400000000c0000221", 16)),
    "2001:db8:85a3:0:0:8a2e:370:7334"            -> ResultContainer(6, BigInt("20010db885a3000000008a2e03707334", 16)),
    "2001:db8::1428:57ab"                        -> ResultContainer(6, BigInt("20010db80000000000000000142857ab", 16)),
    "2001:db8::8d3:0:0:0"                        -> ResultContainer(6, BigInt("20010db80000000008d3000000000000", 16)),
    "256.0.0.0"                                  -> IPInvalidAddressComponents(4, remark = "Invalid octets."),
    "2605:2700:0:3::4713:93e3"                   -> ResultContainer(6, BigInt("260527000000000300000000471393e3", 16)),
    "::"                                         -> ResultContainer(6, BigInt("00000000000000000000000000000000", 16)),
    "1::8"                                       -> ResultContainer(6, BigInt("00010000000000000000000000000008", 16)),
    "::1"                                        -> ResultContainer(6, BigInt("00000000000000000000000000000001", 16)),
    "::192.168.0.1"                              -> ResultContainer(6, BigInt("000000000000000000000000c0a80001", 16)),
    "::255.255.255.255"                          -> ResultContainer(6, BigInt("000000000000000000000000ffffffff", 16)),
    "http:/[::255.255.255.255]:65536" ->
      IPInvalidAddressComponents(6, BigInt("000000000000000000000000ffffffff", 16), Some(65536), remark = "Port number out of range."),
    "::2:3:4:5:6:7:8"                            -> ResultContainer(6, BigInt("00000002000300040005000600070008", 16), strictRFC5952 = false),
    "::8"                                        -> ResultContainer(6, BigInt("00000000000000000000000000000008", 16)),
    "::c0a8:1"                                   -> ResultContainer(6, BigInt("000000000000000000000000c0a80001", 16)),
    "::ffff:0:255.255.255.255"                   -> ResultContainer(6, BigInt("0000000000000000ffff0000ffffffff", 16)),
    "::ffff:127.0.0.0.1"                         -> IPInvalidAddressComponents(4, remark = "Address puntation error: ':127.0.0.0.1'."),
    "::ffff:127.0.0.1"                           -> ResultContainer(6, BigInt("00000000000000000000ffff7f000001", 16)),
    "::ffff:192.168.0.1"                         -> ResultContainer(6, BigInt("00000000000000000000ffffc0a80001", 16)),
    "::ffff:192.168.173.22"                      -> ResultContainer(6, BigInt("00000000000000000000ffffc0a8ad16", 16)),
    "::ffff:255.255.255.255"                     -> ResultContainer(6, BigInt("00000000000000000000ffffffffffff", 16)),
    "::ffff:71.19.147.227"                       -> ResultContainer(6, BigInt("00000000000000000000ffff471393e3", 16)),
    "1:2:3:4:5:6:7::"                            -> ResultContainer(6, BigInt("00010002000300040005000600070000", 16), strictRFC5952 = false),
    "8000:2:3:4:5:6:7::"                         -> ResultContainer(6, BigInt("80000002000300040005000600070000", 16), strictRFC5952 = false),
    "1:2:3:4:5:6::8"                             -> ResultContainer(6, BigInt("00010002000300040005000600000008", 16), strictRFC5952 = false),
    "1:2:3:4:5::8"                               -> ResultContainer(6, BigInt("00010002000300040005000000000008", 16)),
    "1::7:8"                                     -> ResultContainer(6, BigInt("00010000000000000000000000070008", 16)),
    "a::b::1"                                    -> IPInvalidAddressComponents(remark = "Noise found: 'a::b::1'."),
    "fff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"     -> ResultContainer(6, BigInt("0fffffffffffffffffffffffffffffff", 16)),
    "FFFF:ffff:ffff:ffff:ffff:ffff:ffff:ffff"    -> ResultContainer(6, BigInt("ffffffffffffffffffffffffffffffff", 16), strictRFC5952 = false),
    "ffff:ffff:ffff:fffg:ffff:ffff:ffff:ffff"    -> IPInvalidAddressComponents(remark = "No match at all: 'ffff:ffff:ffff:fffg…'."),
    "g::1"                                       -> IPInvalidAddressComponents(6, remark ="Invalid input 'g::1'."),
    "[g::1]:192.0.2.33"                          -> IPInvalidAddressComponents(4, remark = "Address puntation error: ':192.0.2.33'."),
    "1:2:3:4:5:6:7:8"                            -> ResultContainer(6, BigInt("00010002000300040005000600070008", 16)),
    "1:2:3:4:5::7:8"                             -> ResultContainer(6, BigInt("00010002000300040005000000070008", 16), strictRFC5952 = false),
    "1:2:3:4::6:7:8"                             -> ResultContainer(6, BigInt("00010002000300040000000600070008", 16), strictRFC5952 = false),
    "1:2:3:4::8"                                 -> ResultContainer(6, BigInt("00010002000300040000000000000008", 16)),
    "1:2:3::5:6:7:8"                             -> ResultContainer(6, BigInt("00010002000300000005000600070008", 16), strictRFC5952 = false),
    "1:2:3::8"                                   -> ResultContainer(6, BigInt("00010002000300000000000000000008", 16)),
    "1:2::4:5:6:7:8"                             -> ResultContainer(6, BigInt("00010002000000040005000600070008", 16), strictRFC5952 = false),
    "1:2::8"                                     -> ResultContainer(6, BigInt("00010002000000000000000000000008", 16)),
    "1::3:4:5:6:7:8"                             -> ResultContainer(6, BigInt("00010000000300040005000600070008", 16), strictRFC5952 = false),
    "1::4:5:6:7:8"                               -> ResultContainer(6, BigInt("00010000000000040005000600070008", 16)),
    "1::5:6:7:8"                                 -> ResultContainer(6, BigInt("00010000000000000005000600070008", 16)),
    "[1::6:7:8]"                                 -> ResultContainer(6, BigInt("0010000000000000000000600070008", 16)),
    "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"    -> ResultContainer(6, BigInt("ffffffffffffffffffffffffffffffff", 16)),
    "64:ff9b::192.0.2.33"                        -> ResultContainer(6, BigInt("0064ff9b0000000000000000c0000221", 16)),
    "64:ff9b::256.0.2.33" ->
      IPInvalidAddressComponents(6, BigInt("0064ff9b000000000000000000000000", 16), remark = "Invalid octets."),
    "[2001:db8:85a3:8d3:1319:8a2e:370:7348]:443" -> ResultContainer(6, BigInt("20010db885a308d313198a2e03707348", 16), Some(443)),
    "[2001:db8:85a3:8d3:1319:8a2e:370:7348]:100000" ->
      IPInvalidAddressComponents(6, BigInt("20010db885a308d313198a2e03707348", 16), Some(100000), remark = "Port number out of range."),
    "[2605:2700:0:3::4713:93e3]:80"              -> ResultContainer(6, BigInt("260527000000000300000000471393e3", 16), Some(80)),
    "[::ffff:192.168.0.1]:22"                    -> ResultContainer(6, BigInt("00000000000000000000ffffc0a80001", 16), Some(22)),
    "[::ffff:192.168.173.22]:80"                 -> ResultContainer(6, BigInt("00000000000000000000ffffc0a8ad16", 16), Some(80)),
    "[::ffff:71.19.147.227]:80"                  -> ResultContainer(6, BigInt("00000000000000000000FFFF471393E3", 16), Some(80)),
    "2001:0DB8:0:0:0:0:1428:57AB"                -> ResultContainer(6, BigInt("20010DB80000000000000000142857AB", 16), strictRFC5952 = false),
    "2001:0DB8:0:0:8D3:0:0:0"                    -> ResultContainer(6, BigInt("20010DB80000000008D3000000000000", 16), strictRFC5952 = false),
    "2001:DB8:0:0:8D3::"                         -> ResultContainer(6, BigInt("20010DB80000000008D3000000000000", 16), strictRFC5952 = false),
    "2001:DB8:3:4::192.0.2.33"                   -> ResultContainer(6, BigInt("20010DB80003000400000000C0000221", 16), strictRFC5952 = false),
    "2001:DB8:85A3:0:0:8A2E:370:7334"            -> ResultContainer(6, BigInt("20010DB885A3000000008A2E03707334", 16), strictRFC5952 = false),
    "2001:DB8::1428:57AB"                        -> ResultContainer(6, BigInt("20010DB80000000000000000142857AB", 16), strictRFC5952 = false),
    "2001:DB8::8D3:0:0:0"                        -> ResultContainer(6, BigInt("20010DB80000000008D3000000000000", 16), strictRFC5952 = false),
    "2605:2700:0:3::4713:93E3"                   -> ResultContainer(6, BigInt("260527000000000300000000471393E3", 16), strictRFC5952 = false),
    "::192.168.0.1"                              -> ResultContainer(6, BigInt("000000000000000000000000C0A80001", 16)),
    "::255.255.255.255"                          -> ResultContainer(6, BigInt("000000000000000000000000FFFFFFFF", 16)),
    "::C0A8:1"                                   -> ResultContainer(6, BigInt("000000000000000000000000c0a80001", 16), strictRFC5952 = false),
    "::FFFF:0:255.255.255.255"                   -> ResultContainer(6, BigInt("0000000000000000FFFF0000FFFFFFFF", 16), strictRFC5952 = false),
    "::FFFF:127.0.0.0.1"                         -> IPInvalidAddressComponents(4, remark = "Address puntation error: ':127.0.0.0.1'."),
    "::FFFF:127.0.0.1"                           -> ResultContainer(6, BigInt("00000000000000000000FFFF7F000001", 16), strictRFC5952 = false),
    "::FFFF:192.168.0.1"                         -> ResultContainer(6, BigInt("00000000000000000000FFFFC0A80001", 16), strictRFC5952 = false),
    "::FFFF:192.168.173.22"                      -> ResultContainer(6, BigInt("00000000000000000000FFFFC0A8AD16", 16), strictRFC5952 = false),
    "::FFFF:255.255.255.255"                     -> ResultContainer(6, BigInt("00000000000000000000FFFFFFFFFFFF", 16), strictRFC5952 = false),
    "::FFFF:71.19.147.227"                       -> ResultContainer(6, BigInt("00000000000000000000FFFF471393E3", 16), strictRFC5952 = false),
    "[1::]:80"                                   -> ResultContainer(6, BigInt("00010000000000000000000000000000", 16), Some(80)),
    "[2001:DB8:85A3:8D3:1319:8A2E:370:7348]:443" -> ResultContainer(6, BigInt("20010db885a308d313198a2e03707348", 16), Some(443), strictRFC5952 = false),
    "[2605:2700:0:3::4713:93E3]:80"              -> ResultContainer(6, BigInt("260527000000000300000000471393e3", 16), Some(80), strictRFC5952 = false),
    "[::1]:80"                                   -> ResultContainer(6, BigInt("00000000000000000000000000000001", 16), Some(80)),
    "[::1]:65536" ->
      IPInvalidAddressComponents(6, BigInt("00000000000000000000000000000001", 16), Some(65536), remark = "Port number out of range."),
    "[::]:80"                                    -> ResultContainer(6, BigInt("00000000000000000000000000000000", 16), Some(80)),
    "[::FFFF:192.168.0.1]:22"                    -> ResultContainer(6, BigInt("00000000000000000000ffffc0a80001", 16), Some(22), strictRFC5952 = false),
    "[::FFFF:192.168.173.22]:80"                 -> ResultContainer(6, BigInt("00000000000000000000ffffc0a8ad16", 16), Some(80), strictRFC5952 = false),
    "[::FFFF:71.19.147.227]:80"                  -> ResultContainer(6, BigInt("00000000000000000000ffff471393e3", 16), Some(80), strictRFC5952 = false),
    "A::B::1"                                    -> IPInvalidAddressComponents(remark = "Noise found: 'A::B::1'."),
    "FFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF"     -> ResultContainer(6, BigInt("0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", 16), strictRFC5952 = false),
    "FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF"    -> ResultContainer(6, BigInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF", 16), strictRFC5952 = false),
    "FFFF:FFFF:FFFF:FFFG:FFFF:FFFF:FFFF:FFFF"    -> IPInvalidAddressComponents(remark = "No match at all: 'FFFF:FFFF:FFFF:FFFG…'."),
    "G::1"                                       -> IPInvalidAddressComponents(6, remark = "Invalid input 'G::1'."),
    "64:FF9B::192.0.2.33"                        -> ResultContainer(6, BigInt("0064FF9B0000000000000000C0000221", 16), strictRFC5952 = false),
    "64:FF9B::256.0.2.33" -> IPInvalidAddressComponents(6, BigInt("0064FF9B000000000000000000000000", 16), remark = "Invalid octets.")
    )

  def IPInvalidAddressComponents(version: Int = 0,
                                 address: BigInt = BigInt(0),
                                 port: Option[Int] = None,
                                 valid: Boolean = false,
                                 remark: String = "",
                                 strict: Boolean = false) = ResultContainer(version, address, port, valid, remark, strict)

  case class ResultContainer(version: Int,
                             address: BigInt,
                             port: Option[Int] = None,
                             valid: Boolean = true,
                             remark: String = "",
                             strictRFC5952: Boolean = true)

  class IpAddress(val originalString: String) {

    import IpAddress._

    val (usedPattern, result: ResultContainer) = originalString match {
      case trapPattern() => (trapPattern, IPInvalidAddressComponents(remark = s"Noise found: '${shortener(originalString)}'."))
      case allIpV6PortedPatternsCompiled(adr, port) => parseIpV6(adr, Option(port).map(_.toInt))
      case allIpV6UnspecPortPatternsCompiled(adr) => parseIpV6(adr)
      case ipV4PortSpecCompiled(adr, port) => (ipV4PortSpecCompiled, parseIpV4(adr, Option(port).map(_.toInt)))
      case _ => ("Exhausted of all matches.", IPInvalidAddressComponents(remark = s"No match at all: '${shortener(originalString, 19)}'."))
    }

    override def toString: String = {
      def hexAddr = if (result.version == 6) f"${result.address}%#034x" else f"${result.address}%#010x"

      def validInd = if (result.valid) '\u2714' else '\u2718'

      def rfc5952 = if (result.strictRFC5952) "comply" else "broken"

      def version = result.version match {
        case 0 => "   ?"
        case 4 => "IPv4"
        case 6 => "IPv6"
      }

      def surround(s: String) = if (result.valid) s" $s " else s"($s)"

      def port = if (result.port.isDefined) surround(result.port.get.toString) else if (result.valid) " " else "? "

      def hexAddrField = f"${if (result.valid || result.address != 0) surround(hexAddr) else "? "}%36s "

      f"${shortener(originalString, 45)}%46s $version $validInd $rfc5952 $hexAddrField $port%8s ${result.remark}%-40s $usedPattern"
    }

    def shortener(s: String, maxlength: Int = 12): String = {
      val size = s.length()
      s.substring(0, math.min(size, maxlength)) + (if (size > maxlength) "…" else "")
    }

    private def parseIpV6(ipAddress: String, port: Option[Int] = None): (String, ResultContainer) = {

      def colonedStringToBigInt(colonedString: String): (BigInt, Int) = {
        // Compressed zeroes expansion
        val ar = if (colonedString contains "::") colonedString.split("::", 2) else Array("", colonedString)
        val (left, right) = (ar.head.split(':').filterNot(_.isEmpty), ar(1).split(':').filterNot(_.isEmpty))
        val sixteenBitExpansions = 8 - (right.length + left.length)

        ((left ++ Seq.fill(sixteenBitExpansions)("0") ++ right)
          .map(BigInt(_, 16).toLong).map(BigInt(_)).reduceLeft((acc, i) => (acc << 16) | i),
          sixteenBitExpansions)
      }

      def parseEmbeddedV4(seg: String, ip4Seg: String, usedRegEx: String): (String, ResultContainer) = {
        val (ip4, ip6Parser, test) =
          (parseIpV4(ip4Seg), colonedStringToBigInt(seg.replaceFirst(ipV4Regex("3"), "0:0")), portNumberTest(port))

        (usedRegEx, ResultContainer(originalString, 6, ip4.address + ip6Parser._1, port,
          ip4.valid && test.isEmpty, ip4.remark + test, ip4.valid && test.isEmpty))
      }

      if (!ipAddress.forall((('A' to 'F') ++ ('a' to 'f') ++ ('0' to '9') ++ Vector(':', '.')).contains(_)))
        ("[^:.[0-9][A-F][a-f]]", IPInvalidAddressComponents(6, remark = s"Invalid input '${shortener(ipAddress)}'."))
      else
        ipAddress match {
          case pattern10Compiled(seg, ip4Seg) => parseEmbeddedV4(seg, ip4Seg, pattern10Compiled.toString())
          case pattern11Compiled(seg, ip4Seg) => parseEmbeddedV4(seg, ip4Seg, pattern11Compiled.toString())
          case ip6PatternsRawCompiled(seg, _*) =>
            val (ip6Parser, test) = (colonedStringToBigInt(seg), portNumberTest(port))

            (ip6PatternsRawCompiled.toString(),
              ResultContainer(ipAddress, 6, ip6Parser._1, port,
                valid = test.isEmpty, test, strictRFC5952 = ip6Parser._2 != 1 && test.isEmpty))
          case _ => ("V6 match exhausted.", IPInvalidAddressComponents(6, remark = "V6 address puntation error."))
        }
    } // parseIpV6


    private def parseIpV4(sIP: String, port: Option[Int] = None): ResultContainer = {

      def wordsToNum(words: Array[Long]): Long = words.reduceLeft((acc, i) => (acc << 8) | i)

      if (sIP.head.isDigit && sIP.matches(ipV4Regex("3"))) {
        val octets = sIP.split('.').map(_.toLong)
        if (octets.forall(_ < 256)) {
          val portNumberOK = portNumberTest(port)
          ResultContainer(4, BigInt(wordsToNum(octets)), port, portNumberOK.isEmpty, portNumberOK, portNumberOK.isEmpty)
        } else IPInvalidAddressComponents(4, remark = "Invalid octets.")
      }
      else IPInvalidAddressComponents(4, remark = s"Address puntation error: '${shortener(sIP)}'.")
    }

    private def portNumberTest(port: Option[Int]) = if (port.isEmpty || port.get < math.pow(2, 16)) "" else "Port number out of range."
  } // IpAddress

  object IpAddress {
    val (ip6PatternsRawCompiled, pattern11Compiled) = (ipV6Patterns.mkString("(", "|", ")").r, embeddedV4patterns()(1).r)
    val (trapPattern, pattern10Compiled) = (""".*?(?:(?:\w*:{2,}?){2,}?\w)|(?:\[?)""".r, embeddedV4patterns().head.r)
    val allIpV6PortedPatternsCompiled = ("""[^\\.]*?\[(""" + allIpV6 +""")\](?::(\d{1,6}))?[^\.:]*?""").r
    val allIpV6UnspecPortPatternsCompiled = (""".*?(""" + allIpV6 +""")[^\.:]*?""").r
    val ipV4PortSpecCompiled = s".*?([:.\\]]?${ipV4Regex()})(?::(\\d{1,6}))?.*?".r

    // Make a regex pattern with non-capturing groups by the disabling the capturing group syntax (?:).
    def allIpV6 = (embeddedV4patterns("(?:") ++ ipV6Patterns).map(s => "(?:" + s.drop(1)).mkString("|")

    def ipV6Patterns = {
      def ipV6SegRegWC = """\w{1,4}"""

      Seq(
        s"((?::(?:(?::$ipV6SegRegex){1,7}|:)))",
        s"((?:$ipV6SegRegWC:(?::$ipV6SegRegex){1,6}))",
        s"((?:$ipV6SegRegex:){1,2}(?::$ipV6SegRegex){1,5})",
        s"((?:$ipV6SegRegex:){1,3}(?::$ipV6SegRegex){1,4})",
        s"((?:$ipV6SegRegex:){1,4}(?::$ipV6SegRegex){1,3})",
        s"((?:$ipV6SegRegex:){1,5}(?::$ipV6SegRegex){1,2})",
        s"((?:$ipV6SegRegex:){1,6}:$ipV6SegRegex)",
        s"((?:$ipV6SegRegex:){1,7}:)",
        s"((?:$ipV6SegRegex:){7}$ipV6SegRegex)"
      )
    }

    private def embeddedV4patterns(nonCapturePrefix: String = "(") =
      Seq(s"(::(?:(?:FFFF|ffff)(?::0{1,4}){0,1}:){0,1}$nonCapturePrefix${ipV4Regex("3")}))",
        s"((?:$ipV6SegRegex:){1,4}:$nonCapturePrefix${ipV4Regex("3")}))")

    private def ipV6SegRegex = """[\dA-Fa-f]{1,4}"""

    private def ipV4Regex(octets: String = "3,") = s"(?:\\d{1,3}\\.){$octets}\\d{1,3}"
  }

  object ResultContainer {
    def apply(orginalString: String, version: Int,
              address: BigInt, port: Option[Int],
              valid: Boolean, remark: String,
              strictRFC5952: Boolean): ResultContainer =
    // To comply with strictRFC5952 all alpha character must be lowercase too.
      this (version, address, port, valid, remark, strictRFC5952 && !orginalString.exists(_.isUpper))
  }

  {
    val headline = Seq(f"${"IP addresses to be parsed. "}%46s", "Ver.", f"${"S"}%1s", "RFC5952",
      f"${"Hexadecimal IP address"}%34s", f"${"Port "}%10s", f"${" Remark"}%-40s", f"${" Effective RegEx"}%-40s")

    println(headline.mkString("|") + "\n" + headline.map(s => "-" * s.length).mkString("+"))

    val cases: Set[IpAddress] = myCases.keySet.map(new IpAddress(_))

    println(cases.toList.sortBy(s => (s.originalString.length, s.originalString)).mkString("\n"))
    logInfo(s"Concluding: ${myCases.size} cases processed, ${cases.count(_.result.valid)} valid ✔ and ${cases.count(!_.result.valid)} invalid ✘.")
    logInfo("Successfully completed without errors.")

    def logInfo(info: String) {
      println(f"[Info][${System.currentTimeMillis() - executionStart}%5d ms]" + info)
    }
  }

} // IPparser cloc.exe : 235 loc
