package xyz.hyperreal.rosettacodeCompiler

import scala.collection.mutable.{ArrayBuffer, HashMap}
import scala.io.Source

object CodeGenerator {

  def fromStdin = fromSource(Source.stdin)

  def fromString(src: String) = fromSource(Source.fromString(src))

  def fromSource(ast: Source) = {
    val vars              = new HashMap[String, Int]
    val strings           = new ArrayBuffer[String]
    val code              = new ArrayBuffer[String]
    var s: Stream[String] = ast.getLines.toStream

    def line =
      if (s.nonEmpty) {
        val n = s.head

        s = s.tail

        n.split(" +", 2) match {
          case Array(n) => n
          case a        => a
        }
      } else
        sys.error("unexpected end of AST")

    def variableIndex(name: String) =
      vars get name match {
        case None =>
          val idx = vars.size

          vars(name) = idx
          idx
        case Some(idx) => idx
      }

    def stringIndex(s: String) =
      strings indexOf s match {
        case -1 =>
          val idx = strings.length

          strings += s
          idx
        case idx => idx
      }

    var loc = 0

    def addSimple(inst: String) = {
      code += f"$loc%4d $inst"
      loc += 1
    }

    def addOperand(inst: String, operand: String) = {
      code += f"$loc%4d $inst%-5s $operand"
      loc += 5
    }

    def fixup(inst: String, idx: Int, at: Int) = code(idx) = f"$at%4d $inst%-5s (${loc - at - 1}) $loc"

    generate
    addSimple("halt")
    println(s"Datasize: ${vars.size} Strings: ${strings.length}")

    for (s <- strings)
      println(s)

    println(code mkString "\n")

    def generate: Unit =
      line match {
        case "Sequence" =>
          generate
          generate
        case ";" =>
        case "Assign" =>
          val idx =
            line match {
              case Array("Identifier", name: String) =>
                variableIndex(name)
              case l => sys.error(s"expected identifier: $l")
            }

          generate
          addOperand("store", s"[$idx]")
        case Array("Identifier", name: String) => addOperand("fetch", s"[${variableIndex(name)}]")
        case Array("Integer", n: String)       => addOperand("push", s"$n")
        case Array("String", s: String)        => addOperand("push", s"${stringIndex(s)}")
        case "If" =>
          generate

          val cond    = loc
          val condidx = code.length

          addOperand("", "")
          s = s.tail
          generate

          if (s.head == ";") {
            s = s.tail
            fixup("jz", condidx, cond)
          } else {
            val jump    = loc
            val jumpidx = code.length

            addOperand("", "")
            fixup("jz", condidx, cond)
            generate
            fixup("jmp", jumpidx, jump)
          }
        case "While" =>
          val start = loc

          generate

          val cond    = loc
          val condidx = code.length

          addOperand("", "")
          generate
          addOperand("jmp", s"(${start - loc - 1}) $start")
          fixup("jz", condidx, cond)
        case op =>
          generate
          generate
          addSimple(
            op match {
              case "Prti"         => "prti"
              case "Prts"         => "prts"
              case "Prtc"         => "prtc"
              case "Add"          => "add"
              case "Subtract"     => "sub"
              case "Multiply"     => "mul"
              case "Divide"       => "div"
              case "Mod"          => "mod"
              case "Less"         => "lt"
              case "LessEqual"    => "le"
              case "Greater"      => "gt"
              case "GreaterEqual" => "ge"
              case "Equal"        => "eq"
              case "NotEqual"     => "ne"
              case "And"          => "and"
              case "Or"           => "or"
              case "Negate"       => "neg"
              case "Not"          => "not"
            }
          )
      }
  }

}
