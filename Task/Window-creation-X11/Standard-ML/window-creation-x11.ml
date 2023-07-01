open XWindows ;
val dp =  XOpenDisplay "" ;
val w = XCreateSimpleWindow (RootWindow dp) origin (Area {x=0,y=0,w=400,h=300}) 3 0 0xffffff ;
XMapWindow w;
XFlush dp ;
XDrawString w (DefaultGC dp) (XPoint {x=10,y=50})  "Hello World!" ;
XFlush dp ;
