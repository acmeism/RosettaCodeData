package xyz.hyperreal

import java.io.ByteArrayOutputStream

package object rosettacodeCompiler {

  val escapes = "\\\\b|\\\\f|\\\\t|\\\\r|\\\\n|\\\\\\\\|\\\\\"" r

  def unescape(s: String) =
    escapes.replaceAllIn(s, _.matched match {
      case "\\b"  => "\b"
      case "\\f"  => "\f"
      case "\\t"  => "\t"
      case "\\r"  => "\r"
      case "\\n"  => "\n"
      case "\\\\" => "\\"
      case "\\\"" => "\""
    })

  def capture(thunk: => Unit) = {
    val buf = new ByteArrayOutputStream

    Console.withOut(buf)(thunk)
    buf.toString
  }

}
