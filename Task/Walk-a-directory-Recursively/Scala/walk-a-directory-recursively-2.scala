package test.io.utils

import io.utils.RichFile.toRichFile // this makes implicit toRichFile active
import java.io.File

object Test extends App {
  val root = new File("/home/user")
  for(f <- root.andTree) Console.println(f)

 // filtering comes for free
 for(f <- root.andTree; if f.getName.endsWith(".mp3")) Console.println(f)
}
