import java.io.{File, FileWriter, IOException}

  def writeStringToFile(file: File, data: String, appending: Boolean = false) =
    using(new FileWriter(file, appending))(_.write(data))

  def using[A <: {def close() : Unit}, B](resource: A)(f: A => B): B =
    try f(resource) finally resource.close()

  try {
    val file = File.createTempFile("_rosetta", ".passwd")
    // Just an example how you can fill a file
    using(new FileWriter(file))(writer => rawDataIter.foreach(line => writer.write(line)))
    scala.compat.Platform.collectGarbage() // JVM Windows related bug workaround JDK-4715154
    file.deleteOnExit()
    println(file)
  } catch {
    case e: IOException => println(s"Running Example failed: ${e.getMessage}")
  }
