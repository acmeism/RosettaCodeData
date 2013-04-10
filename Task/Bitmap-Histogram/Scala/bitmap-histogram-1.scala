object BitmapOps {
   def histogram(bm:RgbBitmap)={
      val hist=new Array[Int](255)
      for(x <- 0 until bm.width; y <- 0 until bm.height; l=luminosity(bm.getPixel(x,y)))
         hist(l)+=1
      hist
   }

   def histogram_median(hist:Array[Int])={
      var from=0
      var to=hist.size-1
      var left=hist(from)
      var right=hist(to)

      while(from!=to){
         if (left<right)
            {from+=1; left+=hist(from)}
         else
            {to-=1; right+=hist(to)}
      }
      from
   }

   def monochrom(bm:RgbBitmap, threshold:Int)={
      val image=new RgbBitmap(bm.width, bm.height)
      val c1=Color.BLACK
      val c2=Color.WHITE
      for(x <- 0 until bm.width; y <- 0 until bm.height; l=luminosity(bm.getPixel(x,y)))
         image.setPixel(x, y, if(l>threshold) c2 else c1)
      image		
   }
}
