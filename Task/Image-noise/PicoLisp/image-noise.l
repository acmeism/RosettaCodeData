(javac "ImageNoise" "JPanel" NIL
      "java.util.*"
      "java.awt.*" "java.awt.image.*" "javax.swing.*" )

   int DX, DY;
   int[] Pixels;
   MemoryImageSource Source;
   Image Img;
   Random Rnd;

   public ImageNoise(int dx, int dy) {
      DX = dx;
      DY = dy;
      Pixels = new int[DX * DY];
      Source = new MemoryImageSource(DX, DY, Pixels, 0, DX);
      Source.setAnimated(true);
      Img = createImage(Source);
      Rnd = new Random();
   }

   public void paint(Graphics g) {update(g);}
   public void update(Graphics g) {g.drawImage(Img, 0, 0, this);}

   public void draw() {
      for (int i = 0; i < Pixels.length; ++i) {
         int c = Rnd.nextInt(255);
         Pixels[i] = 0xFF000000 | c<<16 | c<<8 | c;
      }
      Source.newPixels();
      paint(getGraphics());
   }
/**/

(de imageNoise (DX DY Fps)
   (let
      (Frame (java "javax.swing.JFrame" T "Image Noise")
         Noise (java "ImageNoise" T DX DY)
         Button (java "javax.swing.JButton" T "OK") )
      (java Frame "add" Noise)
      (java Frame "add" "South" Button)
      (java Button "addActionListener"
         (interface "java.awt.event.ActionListener"
            'actionPerformed '((Ev) (bye)) ) )
      (java Frame "setSize" DX DY)
      (java Frame "setVisible" T)
      (task (/ -1000 Fps) 0
         Image Noise
         (java Image "draw") ) ) )

# Start with 25 frames per second
(imageNoise 320 240 25)
