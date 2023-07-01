import scala.io.Source

val command = "cmd /c echo Time at %DATE% %TIME%"
val p = Runtime.getRuntime.exec(command)
val sc = Source.fromInputStream(p.getInputStream)
println(sc.mkString)
