package xyz.hyperreal.rosettacodeCompiler

import scala.io.Source
import scala.util.matching.Regex

object LexicalAnalyzer {
  private val EOT = '\u0004'

  val symbols =
    Map(
      "*"  -> "Op_multiply",
      "/"  -> "Op_divide",
      "%"  -> "Op_mod",
      "+"  -> "Op_add",
      "-"  -> "Op_minus",
      "<"  -> "Op_less",
      "<=" -> "Op_lessequal",
      ">"  -> "Op_greater",
      ">=" -> "Op_greaterequal",
      "==" -> "Op_equal",
      "!=" -> "Op_notequal",
      "!"  -> "Op_not",
      "="  -> "Op_assign",
      "&&" -> "Op_and",
      "¦¦" -> "Op_or",
      "("  -> "LeftParen",
      ")"  -> "RightParen",
      "{"  -> "LeftBrace",
      "}"  -> "RightBrace",
      ";"  -> "Semicolon",
      ","  -> "Comma"
    )

  val keywords =
    Map(
      "if"    -> "Keyword_if",
      "else"  -> "Keyword_else",
      "while" -> "Keyword_while",
      "print" -> "Keyword_print",
      "putc"  -> "Keyword_putc"
    )
  val alpha        = ('a' to 'z' toSet) ++ ('A' to 'Z')
  val numeric      = '0' to '9' toSet
  val alphanumeric = alpha ++ numeric
  val identifiers  = StartRestToken("Identifier", alpha + '_', alphanumeric + '_')
  val integers     = SimpleToken("Integer", numeric, alpha, "alpha characters may not follow right after a number")

  val characters =
    DelimitedToken("Integer",
                   '\'',
                   "[^'\\n]|\\\\n|\\\\\\\\" r,
                   "invalid character literal",
                   "unclosed character literal")

  val strings =
    DelimitedToken("String", '"', "[^\"\\n]*" r, "invalid string literal", "unclosed string literal")

  def apply =
    new LexicalAnalyzer(4, symbols, keywords, "End_of_input", identifiers, integers, characters, strings)

  abstract class Token
  case class StartRestToken(name: String, start: Set[Char], rest: Set[Char])                       extends Token
  case class SimpleToken(name: String, chars: Set[Char], exclude: Set[Char], excludeError: String) extends Token
  case class DelimitedToken(name: String, delimiter: Char, pattern: Regex, patternError: String, unclosedError: String)
      extends Token
}

class LexicalAnalyzer(tabs: Int,
                      symbols: Map[String, String],
                      keywords: Map[String, String],
                      endOfInput: String,
                      identifier: LexicalAnalyzer.Token,
                      tokens: LexicalAnalyzer.Token*) {

  import LexicalAnalyzer._

  private val symbolStartChars = symbols.keys map (_.head) toSet
  private val symbolChars      = symbols.keys flatMap (_.toList) toSet
  private var curline: Int     = _
  private var curcol: Int      = _

  def fromStdin = fromSource(Source.stdin)

  def fromString(src: String) = fromSource(Source.fromString(src))

  def fromSource(ast: Source) = {
    curline = 1
    curcol = 1

    var s = (ast ++ Iterator(EOT)) map (new Chr(_)) toStream

    tokenize

    def token(name: String, first: Chr) = println(f"${first.line}%5d ${first.col}%6d $name")

    def value(name: String, v: String, first: Chr) = println(f"${first.line}%5d ${first.col}%6d $name%-14s $v")

    def until(c: Char) = {
      val buf = new StringBuilder

      def until: String =
        if (s.head.c == EOT || s.head.c == c)
          buf.toString
        else {
          buf += getch
          until
        }

      until
    }

    def next = s = s.tail

    def getch = {
      val c = s.head.c

      next
      c
    }

    def consume(first: Char, cs: Set[Char]) = {
      val buf = new StringBuilder

      def consume: String =
        if (s.head.c == EOT || !cs(s.head.c))
          buf.toString
        else {
          buf += getch
          consume
        }

      buf += first
      consume
    }

    def comment(start: Chr): Unit = {
      until('*')

      if (s.head.c == EOT || s.tail.head.c == EOT)
        sys.error(s"unclosed comment ${start.at}")
      else if (s.tail.head.c != '/') {
        next
        comment(start)
      } else {
        next
        next
      }
    }

    def recognize(t: Token): Option[(String, String)] = {
      val first = s

      next

      t match {
        case StartRestToken(name, start, rest) =>
          if (start(first.head.c))
            Some((name, consume(first.head.c, rest)))
          else {
            s = first
            None
          }
        case SimpleToken(name, chars, exclude, excludeError) =>
          if (chars(first.head.c)) {
            val m = consume(first.head.c, chars)

            if (exclude(s.head.c))
              sys.error(s"$excludeError ${s.head.at}")
            else
              Some((name, m))
          } else {
            s = first
            None
          }
        case DelimitedToken(name, delimiter, pattern, patternError, unclosedError) =>
          if (first.head.c == delimiter) {
            val m = until(delimiter)

            if (s.head.c != delimiter)
              sys.error(s"$unclosedError ${first.head.at}")
            else if (pattern.pattern.matcher(m).matches) {
              next
              Some((name, s"$delimiter$m$delimiter"))
            } else
              sys.error(s"$patternError ${s.head.at}")
          } else {
            s = first
            None
          }
      }
    }

    def tokenize: Unit =
      if (s.head.c == EOT)
        token(endOfInput, s.head)
      else {
        if (s.head.c.isWhitespace)
          next
        else if (s.head.c == '/' && s.tail.head.c == '*')
          comment(s.head)
        else if (symbolStartChars(s.head.c)) {
          val first = s.head
          val buf   = new StringBuilder

          while (!symbols.contains(buf.toString) && s.head.c != EOT && symbolChars(s.head.c)) buf += getch

          while (symbols.contains(buf.toString :+ s.head.c) && s.head.c != EOT && symbolChars(s.head.c)) buf += getch

          symbols get buf.toString match {
            case Some(name) => token(name, first)
            case None       => sys.error(s"unrecognized symbol: '${buf.toString}' ${first.at}")
          }
        } else {
          val first = s.head

          recognize(identifier) match {
            case None =>
              find(0)

              @scala.annotation.tailrec
              def find(t: Int): Unit =
                if (t == tokens.length)
                  sys.error(s"unrecognized character ${first.at}")
                else
                  recognize(tokens(t)) match {
                    case None            => find(t + 1)
                    case Some((name, v)) => value(name, v, first)
                  }
            case Some((name, ident)) =>
              keywords get ident match {
                case None          => value(name, ident, first)
                case Some(keyword) => token(keyword, first)
              }
          }
        }

        tokenize
      }
  }

  private class Chr(val c: Char) {
    val line = curline
    val col  = curcol

    if (c == '\n') {
      curline += 1
      curcol = 1
    } else if (c == '\r')
      curcol = 1
    else if (c == '\t')
      curcol += tabs - (curcol - 1) % tabs
    else
      curcol += 1

    def at = s"[${line}, ${col}]"

    override def toString: String = s"<$c, $line, $col>"
  }

}
