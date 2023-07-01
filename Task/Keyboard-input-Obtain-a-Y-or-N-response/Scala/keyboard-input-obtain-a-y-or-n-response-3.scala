import scala.io.{Source, BufferedSource}
val kbd_In: BufferedSource = Source.stdin
//kbd_In.next()
//res?: Char = 'y' not :String = "y"
if (Seq('y', 'Y', 'n', 'Y').contains(kbd_In.next()) ) {println("Typed y|Y|n|N")} else {println("other key")}
