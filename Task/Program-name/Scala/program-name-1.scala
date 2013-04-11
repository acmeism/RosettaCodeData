$ scala ScriptName.scala
Program: ScriptName.scala

$ scalac ScriptName.scala
$ scala -classpath . ScriptName
Program: ScriptName.scala

$ scala
Welcome to Scala version 2.9.1.final (Java HotSpot(TM) 64-Bit Server VM, Java 1.6.0_26).
Type in expressions to have them evaluated.
Type :help for more information.

scala> :load ScriptName.scala
Loading ScriptName.scala...
import scala.util.matching.Regex.MatchIterator
defined module ScriptName

scala> ScriptName.main(Array[String]())
Program: <console>
