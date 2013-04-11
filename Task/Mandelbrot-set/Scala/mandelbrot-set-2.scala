val imgMandel=Mandelbrot.generate()
val mainframe=new MainFrame(){title="Test"; visible=true
   contents=new Label(){icon=new ImageIcon(imgMandel.image)}
}
