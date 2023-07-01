import java.io.File

object CreateFile extends App {
  try { new File("output.txt").createNewFile() }
  catch { case e: Exception => println(s"Exception caught: $e with creating output.txt") }
  try { new File(s"${File.separator}output.txt").createNewFile() }
  catch { case e: Exception => println(s"Exception caught: $e with creating ${File.separator}output.txt") }
  try { new File("docs").mkdir() }
  catch { case e: Exception => println(s"Exception caught: $e with creating directory docs") }
  try { new File(s"${File.separator}docs").mkdir() }
  catch { case e: Exception => println(s"Exception caught: $e with creating directory ${File.separator}docs") }
}
