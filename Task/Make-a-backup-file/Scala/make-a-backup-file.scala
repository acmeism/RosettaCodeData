import java.io.{File, PrintWriter}
import java.nio.file.{Files, Paths, StandardCopyOption}

object Backup extends App {

  def saveWithBackup(filename: String, data: String*): Unit = { //toRealPath() follows symlinks to their ends
    val (file, backFile) = (Paths.get(filename).toRealPath(), new File(filename + ".backup"))
    if (!backFile.exists) { // ensure the backup file exists so we can write to it later
      backFile.createNewFile
    }
    val back = Paths.get(filename + ".backup").toRealPath()
    Files.move(file, back, StandardCopyOption.REPLACE_EXISTING)
    val out = new PrintWriter(file.toFile)

    for (i <- 0 until data.length) {
      out.print(data(i))
      if (i < data.length - 1) out.println()
    }
  }

  saveWithBackup("original.txt", "fourth", "fifth", "sixth")

}
