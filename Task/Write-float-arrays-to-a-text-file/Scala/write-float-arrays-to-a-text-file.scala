import java.io.{File, FileWriter, IOException}

object FloatArray extends App {
  val x: List[Float] = List(1f, 2f, 3f, 1e11f)

  def writeStringToFile(file: File, data: String, appending: Boolean = false) =
    using(new FileWriter(file, appending))(_.write(data))

  def using[A <: {def close() : Unit}, B](resource: A)(f: A => B): B =
    try f(resource) finally resource.close()

  try {
    val file = new File("sqrt.dat")
    using(new FileWriter(file))(writer => x.foreach(x => writer.write(f"$x%.3g\t${math.sqrt(x)}%.5g\n")))
  } catch {
    case e: IOException => println(s"Running Example failed: ${e.getMessage}")
  }
}
