open XWindows ;
val disp =  XOpenDisplay "" ;

val im =
let
   val pos =  #4 (XQueryPointer (RootWindow disp)) ;
in
   XGetImage (RootWindow disp) (MakeRect pos (AddPoint(pos,XPoint{x=1,y=1})) ) AllPlanes ZPixmap
end;

 XGetPixel disp im (XPoint {x=0,y=0}) ;
