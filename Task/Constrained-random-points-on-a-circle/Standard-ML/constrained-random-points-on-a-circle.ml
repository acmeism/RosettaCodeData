open XWindows ;
open Motif ;

val plotWindow = fn coords =>                                                               (*  input list of int*int  within 'dim' *)
let
  val dim    =  {tw=325,th=325} ;
  val shell  =  XtAppInitialise      ""    "demo" "top" [] [ XmNwidth (#tw dim), XmNheight (#th dim) ] ;        (* single call only *)
  val main   =  XmCreateMainWindow   shell    "main"       [ XmNmappedWhenManaged true ]   ;
  val canvas =  XmCreateDrawingArea  main   "drawarea"     [ XmNwidth (#tw dim), XmNheight (#th dim) ] ;
  val usegc  =  DefaultGC (XtDisplay canvas) ;
  val put    =  fn (w,s,t)=> (
                    XSetForeground usegc 0xfffffff ;
                    XFillRectangle (XtWindow canvas) usegc (Area{x=0,y=0,w = #tw dim, h= #th dim})  ;
		    XSetForeground usegc 0  ;
                    XDrawPoints  (XtWindow canvas) usegc (  List.map  (fn (x,y)=>XPoint {x=x,y=y}) coords )  CoordModeOrigin ;
		    t )
in

  (
   XtSetCallbacks   canvas [ (XmNexposeCallback , put) ] XmNarmCallback ;
   XtManageChild    canvas ;
   XtManageChild    main ;
   XtRealizeWidget  shell
  )

end;

val urandomlist =  fn seed => fn n =>
(* put code from (www.rosettacode.org) wiki/Random_numbers#Standard_ML 'urandomlist' here
input : seed and number of drawings *)
end;

val normalizedPts = fn () =>                                                  (* select ([0,1]*[0,1]) points in normalized bandwidth *)
 let
   val realseeds  =  ( 972.1 , 10009.3 ) ;
   val usum       =  fn  (u,v)     => u*(u-1.0) + v*(v-1.0) ;
   val lim        =  ( ~350.0/900.0, ~225.0/900.0 ) ;                                                              (* limits to usum  *)
   val select     =  fn i =>  usum i <= #2 lim  andalso  usum i >= #1 lim  ;                      (* select according to inequalities *)
   val uv         =  ListPair.zip ( urandomlist (#1 realseeds) 2500 , urandomlist (#2 realseeds) 2500 )          (* take 2500 couples *)
 in
   List.take ( List.filter select uv , 1000 )
end ;
