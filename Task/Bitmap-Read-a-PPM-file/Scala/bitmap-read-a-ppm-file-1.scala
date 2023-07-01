import scala.io._
import scala.swing._
import java.io._
import java.awt.Color
import javax.swing.ImageIcon

object Pixmap {
   private case class PpmHeader(format:String, width:Int, height:Int, maxColor:Int)
	
   def load(filename:String):Option[RgbBitmap]={
      implicit val in=new BufferedInputStream(new FileInputStream(filename))
      val header=readHeader
      if(header.format=="P6")
      {
         val bm=new RgbBitmap(header.width, header.height);
         for(y <- 0 until bm.height; x <- 0 until bm.width; c=readColor)
            bm.setPixel(x, y, c)
         return Some(bm)
      }
      None
   }

   private def readHeader(implicit in:InputStream)={
      var format=readLine
		
      var line=readLine
      while(line.startsWith("#"))   //skip comments
         line=readLine

      val parts=line.split("\\s")
      val width=parts(0).toInt
      val height=parts(1).toInt
      val maxColor=readLine.toInt
		
      new PpmHeader(format, width, height, maxColor)
   }

   private def readColor(implicit in:InputStream)=new Color(in.read, in.read, in.read)

   private def readLine(implicit in:InputStream)={
      var out=""
      var b=in.read
      while(b!=0xA){out+=b.toChar; b=in.read}
      out
   }
}
