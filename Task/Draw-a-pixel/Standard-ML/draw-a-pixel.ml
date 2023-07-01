open XWindows ;
open Motif ;

val imgWindow = fn () =>

 let
  val shell  =  XtAppInitialise      ""    "demo" "top" [] [ XmNwidth 320, XmNheight 240 ] ;
  val main   =  XmCreateMainWindow   shell    "main"       [ XmNmappedWhenManaged true ]   ;
  val canvas =  XmCreateDrawingArea  main   "drawarea"     [ XmNwidth 320, XmNheight 240 ] ;
  val usegc  =  DefaultGC (XtDisplay canvas) ;
  val put    =  fn (w,s,t) => ( XSetForeground usegc 0xff0000 ;
                                XDrawPoint (XtWindow canvas) usegc ( XPoint {x=100,y=100} ) ; t);
in

  (
   XtSetCallbacks   canvas [ (XmNexposeCallback , put) ] XmNarmCallback ;
   XtManageChild    canvas ;
   XtManageChild    main ;
   XtRealizeWidget  shell
  )

end;
