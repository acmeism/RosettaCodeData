import scala.io._

object HttpTest {
   def main(args: Array[String]): Unit = {
      //if you are behind a firewall you can configure your proxy
      System.setProperty("http.proxySet", "true")
      System.setProperty("http.proxyHost", "0.0.0.0")
      System.setProperty("http.proxyPort", "8080")
		
      Source.fromURL("http://www.rosettacode.org").getLines.foreach(println)
   }
}
