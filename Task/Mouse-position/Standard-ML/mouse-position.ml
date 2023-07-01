open XWindows ;
val dp =  XOpenDisplay "" ;
val w  =  XCreateSimpleWindow (RootWindow dp) origin (Area {x=0,y=0,w=400,h=300}) 3 0 0xffffff ;
XMapWindow w;
val (focus,_)=( Posix.Process.sleep (Time.fromReal 2.0);         (* time to move from interpreter + activate arbitrary window *)
	        XGetInputFocus dp
              ) ;
XQueryPointer focus ;
XQueryPointer w;
