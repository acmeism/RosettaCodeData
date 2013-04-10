object PixmapTest {
   def main(args: Array[String]): Unit = {
      val img=Pixmap.load("image.ppm").get
      val grayImg=BitmapOps.grayscale(img);
      Pixmap.save(grayImg, "image_gray.ppm")

      val mainframe=new MainFrame(){
         title="Test"
         visible=true
         contents=new Label(){
            icon=new ImageIcon(grayImg.image)
         }
      }
   }
}
