import java.io.{File, FileWriter, IOException}
import scala.io.Source

object RecordAppender extends App {
  val rawDataIt = Source.fromString(rawData).getLines()

  def writeStringToFile(file: File, data: String, appending: Boolean = false) =
    using(new FileWriter(file, appending))(_.write(data))

  def using[A <: {def close() : Unit}, B](resource: A)(f: A => B): B =
    try f(resource) finally resource.close()

  def rawData =
    """jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,jsmith@rosettacode.org:/home/jsmith:/bin/bash
      |jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,jdoe@rosettacode.org:/home/jdoe:/bin/bash
      |xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,xyz@rosettacode.org:/home/xyz:/bin/bash""".stripMargin

  case class Record(account: String,
                    password: String,
                    uid: Int,
                    gid: Int,
                    gecos: Array[String],
                    directory: String,
                    shell: String) {
    def asLine: String = s"$account:$password:$uid:$gid:${gecos.mkString(",")}:$directory:$shell\n"
  }

  object Record {
    def apply(line: String): Record = {
      val token = line.trim.split(":")
      require((token != null) || (token.length == 7))
      this(token(0).trim,
        token(1).trim,
        Integer.parseInt(token(2).trim),
        Integer.parseInt(token(3).trim),
        token(4).split(","),
        token(5).trim,
        token(6).trim)
    }
  }

  try {
    val file = File.createTempFile("_rosetta", ".passwd")
    using(new FileWriter(file))(writer => rawDataIt.take(2).foreach(line => writer.write(Record(line).asLine)))

    writeStringToFile(file, Record(rawDataIt.next()).asLine, appending = true) // Append a record

    Source.fromFile(file).getLines().foreach(line => {
      if (line startsWith """xyz""") print(s"Selected record: ${Record(line).asLine}")
    })
    scala.compat.Platform.collectGarbage() // JVM Windows related bug workaround JDK-4715154
    file.deleteOnExit()
  } catch {
    case e: IOException => println(s"Running Example failed: ${e.getMessage}")
  }
} // 57 lines
