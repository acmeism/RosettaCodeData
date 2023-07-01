open XWindows ;
open Motif ;

val showWindow = fn () =>

 let
  val shell = XtAppInitialise    ""    "demo" "top" [] [XmNwidth 400, XmNheight 300 ] ;
  val main  = XmCreateMainWindow shell "main" [XmNmappedWhenManaged true ] ;
  val buttn = XmCreateDrawnButton main "stop" [ XmNlabelString "Exit"] ;
  val quit  = fn (w,c,t) => (XtUnrealizeWidget shell; t) ;
 in

  (
  XtSetCallbacks   buttn [ (XmNactivateCallback, quit) ] XmNarmCallback ;
  XtManageChildren [buttn];
  XtManageChild    main;
  XtRealizeWidget  shell
  )

end;
