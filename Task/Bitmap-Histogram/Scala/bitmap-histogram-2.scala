val img=Pixmap.load("image.ppm").get
val hist=BitmapOps.histogram(img)
val mid=BitmapOps.histogram_median(hist);

val mainframe=new MainFrame(){
   title="Test"
   visible=true
   contents=new Label(){
      icon=new ImageIcon(BitmapOps.monochrom(img, mid).image)
   }
}
