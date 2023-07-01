import org.rosettacode.ArithmeticComplex._
import java.awt.Color

object Mandelbrot
{
   def generate(width:Int =600, height:Int =400)={
      val bm=new RgbBitmap(width, height)

      val maxIter=1000
      val xMin = -2.0
      val xMax =  1.0
      val yMin = -1.0
      val yMax =  1.0

      val cx=(xMax-xMin)/width
      val cy=(yMax-yMin)/height

      for(y <- 0 until bm.height; x <- 0 until bm.width){
         val c=Complex(xMin+x*cx, yMin+y*cy)
         val iter=itMandel(c, maxIter, 4)
         bm.setPixel(x, y, getColor(iter, maxIter))
      }
      bm
   }

   def itMandel(c:Complex, imax:Int, bailout:Int):Int={
      var z=Complex()
      for(i <- 0 until imax){
         z=z*z+c;
         if(z.abs > bailout) return i
      }
      imax;
   }

   def getColor(iter:Int, max:Int):Color={
      if (iter==max) return Color.BLACK

      var c=3*math.log(iter)/math.log(max-1.0)
      if(c<1) new Color((255*c).toInt, 0, 0)
      else if(c<2) new Color(255, (255*(c-1)).toInt, 0)
      else new Color(255, 255, (255*(c-2)).toInt)
   }
}
