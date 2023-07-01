open XWindows;
open Motif;

fun toI {x=x,y=y} = {x=Real.toInt  IEEEReal.TO_NEAREST x,y=Real.toInt  IEEEReal.TO_NEAREST y}  ;


fun drawOnTop win usegc ht hs {x=l1,y=l2} {x=r1,y=r2} =
 let
  val xy = {x=l1 - ht * (l2-r2) , y = l2 - ht * (r1-l1) }
  val zt = {x=r1 - ht * (l2-r2) , y=  r2 - ht * (r1-l1) }
  val ab = {x= ( (#x xy + #x zt) + hs * (#y zt - #y xy ) )/2.0 ,  y =  ( (#y zt + #y xy) - hs * (#x zt - #x xy )) /2.0 }
 in

  if abs (l1 - #x xy ) < 0.9 andalso abs (l2 - #y xy ) < 0.9
   then   XFlush (XtDisplay win)
   else
    (XFillPolygon (XtWindow win) usegc [ (XPoint o toI) {x=l1,y=l2},
                                         (XPoint o toI ) xy ,
				         (XPoint o toI ) ab ,
				         (XPoint o toI ) zt ,
				         (XPoint o toI ) {x=r1,y=r2} ] Convex CoordModeOrigin  ;
  drawOnTop win usegc (0.87*ht) hs xy ab ;
  drawOnTop win usegc (0.93*ht) hs ab zt )

end ;


val demoWindow = fn () =>
let
  val shell  =  XtAppInitialise       ""    "tree" "top" []  [ XmNwidth 800, XmNheight 650] ;
  val main   =  XmCreateMainWindow   shell    "main"         [ XmNmappedWhenManaged true ]  ;
  val canvas =  XmCreateDrawingArea  main   "drawarea"       [ XmNwidth 800, XmNheight 650] ;
  val usegc  =  DefaultGC (XtDisplay canvas) ;
in

  XtSetCallbacks   canvas [ (XmNexposeCallback ,
                               (fn (w,c,t) => ( drawOnTop canvas usegc 8.0 0.85 {x=385.0,y=645.0} {x=415.0,y=645.0} ; t) ) )
			  ] XmNarmCallback ;
   XtManageChild    canvas ;
   XtManageChild    main   ;
   XtRealizeWidget  shell

end ;

demoWindow ();
