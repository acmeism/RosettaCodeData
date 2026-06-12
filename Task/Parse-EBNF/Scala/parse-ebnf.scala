import scala.collection.mutable
import scala.util.{Try, Success, Failure}

case class Token(value: Any, isSequence: Boolean)

class EBNFParser {
  type Sequence = mutable.ArrayBuffer[Any]

  private var src: String = ""
  private var ch: Char = ' '
  private var sdx: Int = 0
  private var token: Token = Token(-1, false)
  private var err: Boolean = false
  private val idents: mutable.ArrayBuffer[String] = mutable.ArrayBuffer[String]()
  private val ididx: mutable.ArrayBuffer[Int] = mutable.ArrayBuffer[Int]()
  private val productions: mutable.ArrayBuffer[Sequence] = mutable.ArrayBuffer[Sequence]()
  private val extras: Sequence = mutable.ArrayBuffer[Any]()
  private val results = Array("pass", "fail")

  private def btoi(b: Boolean): Int = if (b) 1 else 0

  private def invalid(msg: String): Int = {
    err = true
    println(msg)
    sdx = src.length // set to eof
    -1
  }

  private def skipSpaces(): Unit = {
    while (sdx < src.length) {
      ch = src(sdx)
      if (!" \t\r\n".contains(ch)) {
        return
      }
      sdx += 1
    }
  }

  private def getToken(): Unit = {
    // Yields a single character token, one of {}()[]|=.;
    // or Sequence("terminal", string) or Sequence("ident", string) or -1.
    skipSpaces()
    if (sdx >= src.length) {
      token = Token(-1, false)
      return
    }
    val tokstart = sdx
    if ("{}()[]|=.;".contains(ch)) {
      sdx += 1
      token = Token(ch, false)
    } else if (ch == '"' || ch == '\'') {
      val closech = ch
      var tokend = tokstart + 1
      while (tokend < src.length && src(tokend) != closech) {
        tokend += 1
      }
      if (tokend >= src.length) {
        token = Token(invalid("no closing quote"), false)
      } else {
        sdx = tokend + 1
        val seq = mutable.ArrayBuffer[Any]("terminal", src.substring(tokstart + 1, tokend))
        token = Token(seq, true)
      }
    } else if (ch >= 'a' && ch <= 'z') {
      // To simplify things for the purposes of this task,
      // identifiers are strictly a-z only, not A-Z or 1-9.
      while (sdx < src.length && ch >= 'a' && ch <= 'z') {
        sdx += 1
        if (sdx < src.length) {
          ch = src(sdx)
        }
      }
      val seq = mutable.ArrayBuffer[Any]("ident", src.substring(tokstart, sdx))
      token = Token(seq, true)
    } else {
      token = Token(invalid("invalid ebnf"), false)
    }
  }

  private def matchToken(expectedCh: Char): Unit = {
    if (token.value != expectedCh) {
      token = Token(invalid(s"invalid ebnf ($expectedCh expected)"), false)
    } else {
      getToken()
    }
  }

  private def addIdent(ident: String): Int = {
    idents.indexOf(ident) match {
      case -1 =>
        idents += ident
        val k = idents.length - 1
        ididx += -1
        k
      case k => k
    }
  }

  private def factor(): Any = {
    val res = if (token.isSequence) {
      val t = token.value.asInstanceOf[Sequence]
      if (t(0) == "ident") {
        val idx = addIdent(t(1).asInstanceOf[String])
        t += idx
        token = Token(t, true)
      }
      val result = token.value
      getToken()
      result
    } else if (token.value == '[') {
      getToken()
      val seq = mutable.ArrayBuffer[Any]("optional", expression())
      matchToken(']')
      seq
    } else if (token.value == '(') {
      getToken()
      val result = expression()
      matchToken(')')
      result
    } else if (token.value == '{') {
      getToken()
      val seq = mutable.ArrayBuffer[Any]("repeat", expression())
      matchToken('}')
      seq
    } else {
      throw new RuntimeException("invalid token in factor() function")
    }

    res match {
      case seq: mutable.ArrayBuffer[_] if seq.length == 1 => seq(0)
      case other => other
    }
  }

  private def term(): Any = {
    val res = mutable.ArrayBuffer[Any](factor())
    val tokens = Set[Any](-1, '|', '.', ';', ')', ']', '}')

    while (!tokens.contains(token.value)) {
      res += factor()
    }

    if (res.length == 1) res(0) else res
  }

  private def expression(): Any = {
    var res = mutable.ArrayBuffer[Any](term())
    if (token.value == '|') {
      res = mutable.ArrayBuffer[Any]("or", res(0))
      while (token.value == '|') {
        getToken()
        res += term()
      }
    }
    if (res.length == 1) res(0) else res
  }

  private def production(): Any = {
    // Returns a token or -1; the real result is left in 'productions' etc,
    getToken()
    if (token.value != '}') {
      if (token.value == -1) {
        return invalid("invalid ebnf (missing closing })")
      }
      if (!token.isSequence) {
        return -1
      }
      val t = token.value.asInstanceOf[Sequence]
      if (t(0) != "ident") {
        return -1
      }
      val ident = t(1).asInstanceOf[String]
      val idx = addIdent(ident)
      getToken()
      matchToken('=')
      if (token.value == -1) {
        return -1
      }
      val prod = mutable.ArrayBuffer[Any](ident, idx, expression())
      productions += prod
      ididx(idx) = productions.length - 1
    }
    token.value
  }

  def parse(ebnf: String): Int = {
    // Returns +1 if ok, -1 if bad.
    println(s"parse:\n$ebnf ===>\n")
    err = false
    src = ebnf
    sdx = 0
    idents.clear()
    ididx.clear()
    productions.clear()
    extras.clear()

    getToken()
    if (token.isSequence) {
      val t = token.value.asInstanceOf[Sequence]
      t(0) = "title"
      extras += token.value
      getToken()
    }
    if (token.value != '{') {
      return invalid("invalid ebnf (missing opening {)")
    }

    var continue = true
    while (continue) {
      val tokenResult = production()
      if (tokenResult == '}' || tokenResult == -1) {
        continue = false
      }
    }

    getToken()
    if (token.isSequence) {
      val t = token.value.asInstanceOf[Sequence]
      t(0) = "comment"
      extras += token.value
      getToken()
    }
    if (token.value != -1) {
      return invalid("invalid ebnf (missing eof?)")
    }
    if (err) {
      return -1
    }

    val k = ididx.indexOf(-1)
    if (k != -1) {
      return invalid(s"invalid ebnf (undefined:${idents(k)})")
    }

    pprint(productions, "productions")
    pprint(idents, "idents")
    pprint(ididx, "ididx")
    pprint(extras, "extras")
    1
  }

  // Adjusts Scala's normal printing to look more like Phix output.
  private def pprint(ob: Any, header: String): Unit = {
    println(s"\n$header:")
    var pp = ob.toString
    pp = pp.replace("ArrayBuffer(", "{")
    pp = pp.replace(")", "}")
    pp = pp.replace(" ", ", ")
    for (i <- idents.indices) {
      pp = pp.replace(i.toString, i.toString)
    }
    println(pp)
  }

  // The rules that applies() has to deal with are:
  // {factors} - if rule(0) is not string,
  // just apply one after the other recursively.
  // {"terminal", "a1"}       -- literal constants
  // {"or", <e1>, <e2>, ...}  -- (any) one of n
  // {"repeat", <e1>}         -- as per "{}" in ebnf
  // {"optional", <e1>}       -- as per "[]" in ebnf
  // {"ident", <name>, idx}   -- apply the sub-rule

  private def applies(rule: Sequence): Boolean = {
    val wasSdx = sdx // in case of failure
    val r1 = rule(0)

    val result = r1 match {
      case s: String => s match {
        case "terminal" =>
          skipSpaces()
          val r2 = rule(1).asInstanceOf[String]
          r2.forall { char =>
            if (sdx >= src.length || src(sdx) != char) {
              false
            } else {
              sdx += 1
              true
            }
          }
        case "or" =>
          (1 until rule.length).exists(i => applies(rule(i).asInstanceOf[Sequence]))
        case "repeat" =>
          while (applies(rule(1).asInstanceOf[Sequence])) {
            // continue repeating
          }
          true
        case "optional" =>
          applies(rule(1).asInstanceOf[Sequence])
          true
        case "ident" =>
          val i = rule(2).asInstanceOf[Int]
          val ii = ididx(i)
          applies(productions(ii)(2).asInstanceOf[Sequence])
        case _ =>
          throw new RuntimeException("invalid rule in applies() function")
      }
      case _ =>
        // {factors} - if rule(0) is not string, apply one after the other recursively
        rule.forall(r => applies(r.asInstanceOf[Sequence]))
    }

    if (!result) {
      sdx = wasSdx
    }
    result
  }

  private def checkValid(test: String): Unit = {
    src = test
    sdx = 0
    var res = applies(productions(0)(2).asInstanceOf[Sequence])
    skipSpaces()
    if (sdx < src.length) {
      res = false
    }
    println(s""""$test", ${results(1 - btoi(res))}""")
  }

  def main(args: Array[String]): Unit = {
    val ebnfs = Array(
      """"a" {
        |    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
        |} "z" """.stripMargin,

      """{
        |    expr = term { plus term } .
        |    term = factor { times factor } .
        |    factor = number | '(' expr ')' .
        |
        |    plus = "+" | "-" .
        |    times = "*" | "/" .
        |
        |    number = digit { digit } .
        |    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
        |}""".stripMargin,

      """a = "1"""",
      """{ a = "1" ;""",
      """{ hello world = "1"; }""",
      """{ foo = bar . }"""
    )

    val tests = Array(
      Array(
        "a1a3a4a4a5a6",
        "a1 a2a6",
        "a1 a3 a4 a6",
        "a1 a4 a5 a6",
        "a1 a2 a4 a5 a5 a6",
        "a1 a2 a4 a5 a6 a7",
        "your ad here"
      ),
      Array(
        "2",
        "2*3 + 4/23 - 7",
        "(3 + 4) * 6-2+(4*(4))",
        "-2",
        "3 +",
        "(4 + 3"
      )
    )

    for (i <- ebnfs.indices) {
      if (parse(ebnfs(i)) == 1) {
        println("\ntests:")
        if (i < tests.length) {
          tests(i).foreach(checkValid)
        }
      }
      println()
    }
  }
}

object EBNFParser {
  def main(args: Array[String]): Unit = {
    val parser = new EBNFParser()
    parser.main(args)
  }
}
