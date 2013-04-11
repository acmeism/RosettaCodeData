package test.io.utils

import io.utils.RichFile._ // this makes implicit toRichFile active
import java.io.File

object Test extends Application {
  val root = new File("/home/user")
  for(f <- root.andTree) Console.println(f)

 // filtering comes for free
 for(f <- root.andTree; if f.getName.endsWith(".mp3")) Console.println(f)
}
