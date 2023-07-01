open XWindows ;
open Motif ;

structure TTd = Thread.Thread ;
structure TTm = Thread.Mutex ;

val bannerWindow = fn () =>

let
  datatype thron  =  nothr | thr of TTd.thread ;
  val toThr  =  fn thr x=> x;
  val on     =  ref nothr ;
  val mx     =  TTm.mutex ();
  val dim    =  {tw=77,th=14} ;
  val shell  =  XtAppInitialise      ""    "click text to start or redirect" "top" [] [ XmNwidth 320, XmNheight 60 ] ;
  val main   =  XmCreateMainWindow   shell    "main"                                  [ XmNmappedWhenManaged true ]  ;
  val canvas =  XmCreateDrawingArea  main   "drawarea"                                [ XmNwidth (#tw dim), XmNheight (#th dim)] ;

  val usegc  =  DefaultGC (XtDisplay canvas) ;
  val buf    =  XCreatePixmap (RootWindow (XtDisplay shell)) (Area{x=0,y=0,w = #tw dim, h= (#th dim)  }) 24 ;
  val _      =  (XSetBackground usegc 0xfffffff ;
		 XDrawImageString buf usegc (XPoint {x=0,y= (#th dim)-1 } ) "Hello World! ") ;
  val drawparts = fn pos => (
                 XCopyArea buf (XtWindow canvas) usegc ( XPoint {x=pos,y=0} ) (Area{x=0,y=0,w = (#tw dim) - pos , h= #th dim }) ;
                 XCopyArea buf (XtWindow canvas) usegc ( XPoint {x=00,y=0} ) (Area{x=  (#tw dim) - pos   ,y=0,w = pos, h= #th dim }) ;
		 XFlush (XtDisplay canvas) ) ;

  val direct  =  ref 1 ;
  fun shift s =  ( drawparts ( s mod (#tw dim)) ;  Posix.Process.sleep (Time.fromReal 0.1) ;   shift ( s +  (!direct))  ) ;
  val swdir   =  fn () => direct := ~ (!direct) ;
  val finish  =  fn () =>
                    ( if !on <> nothr then  if TTd.isActive (toThr (!on)) then TTd.kill (toThr (!on)) else () else () ;
                       on := nothr );
  val movimg  =  fn ()      =>  ( finish () ; swdir () ;  on :=  thr  (TTd.fork (fn () =>   shift 0,[]) ) ) ;
  val setimg  =  fn (w,s,t) =>  ( finish () ;  drawparts  0 ; t )
in

  (
   XtSetCallbacks    canvas [ (XmNexposeCallback ,  setimg) , (XmNdestroyCallback, (fn (w,c,t)=>(finish();t))) ] XmNarmCallback ;
   XtAddEventHandler canvas [  ButtonPressMask ] false  (fn (w,ButtonPress a)=>  movimg ()|_=> ())  ;
   XtManageChild     canvas ;
   XtManageChild     main   ;
   XtRealizeWidget   shell                                                                        (* add loop here to compile *)
  )

end;
