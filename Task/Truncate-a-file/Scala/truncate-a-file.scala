import java.io.FileOutputStream

object TruncFile extends App {
  if (args.length < 2) println("Usage: java TruncFile fileName newSize")
  else { //turn on "append" so it doesn't clear the file
    val outChan = new FileOutputStream(args(0), true).getChannel()
    val newSize = args(1).toLong
    outChan.truncate(newSize)
  }
}
