open XWindows ;
open Motif ;

val uniformdeviate = fn seed =>
 let
  val in31m = (Real.fromInt o Int32.toInt ) (getOpt (Int32.maxInt,0) );
  val in31 = in31m +1.0;
  val (s1,s2,v) = (41160.0 , 950665216.0 , Real.realFloor seed);
  val (val1,val2) = (v*s1, v*s2);
  val next1 = Real.fromLargeInt (Real.toLargeInt IEEEReal.TO_NEGINF (val1/in31)) ;
  val next2 = Real.rem(Real.realFloor(val2/in31) , in31m );
  val valt = val1+val2 - (next1+next2)*in31m;
  val nextt = Real.realFloor(valt/in31m);
  val valt = valt - nextt*in31m;
 in
  (valt/in31m,valt)
end;


local
 val sizeup = 60.0 ;
 fun toI {x=x,y=y} = {x=Real.toInt  IEEEReal.TO_NEAREST (sizeup *x),y=Real.toInt  IEEEReal.TO_NEAREST (sizeup*y)}  ;
 val next  = [  (fn {x=x,y=y} =>  {x= 0.0,           y= 0.16*y            })
              , (fn {x=x,y=y} =>  {x= 0.85*x+0.04*y, y= ~0.04*x+0.85*y+1.6})
              , (fn {x=x,y=y} =>  {x= 0.2*x-0.26*y,  y= 0.23*x+0.22*y+1.6 })
              , (fn {x=x,y=y} =>  {x= ~0.15*x+0.28*y,y= 0.26*x+0.24*y+0.44}) ] ;
 val seed  = ref 100027.0
in

 fun putNext  1 win usegc coord =  XFlush (XtDisplay win)
 |   putNext  N win usegc coord =
  let
   val (i,ns) =  uniformdeviate ( !seed ) ;
   val _      =  seed := ns  ;
   val fi     =  List.nth (next, List.foldr (fn (a,b) => b + (if i>a then 1 else 0)) 0 [0.1,0.86,0.93,1.0] )  ;
   val nwp    =  fi coord
  in
      (XDrawPoint (XtWindow win) usegc  ( AddPoint ((XPoint o toI) coord, XPoint {x=300,y=0}) )  ;
       putNext (N-1) win usegc nwp  )
  end

end;


val demoWindow = fn () =>
let
  val shell     =  XtAppInitialise      ""    "demo" "top" [] [ XmNwidth 600, XmNheight 700 ] ;
  val main      =  XmCreateMainWindow   shell    "main"       [ XmNmappedWhenManaged true ]  ;
  val canvas    =  XmCreateDrawingArea  main   "drawarea"     [ XmNwidth 600, XmNheight 700] ;
  val usegc     =  DefaultGC (XtDisplay canvas) ;
  val _         =  XSetForeground usegc 0x4a632d ;
  val drawall   =  fn (w,c,t)=> ( XClearWindow (XtWindow canvas ); putNext 1000000 canvas usegc {x=0.0,y=0.0} ; t )
in
  (
   XtSetCallbacks   canvas [ (XmNexposeCallback ,  drawall)  ] XmNarmCallback ;
   XtManageChild    canvas ;
   XtManageChild    main   ;
   XtRealizeWidget  shell
  )
end ;
