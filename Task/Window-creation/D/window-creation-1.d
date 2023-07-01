 module Window;

 import fltk4d.all;

 void main() {
     auto window = new Window(300, 300, "A window");
     window.show;
     FLTK.run;
 }
