open XWindows ;
open Motif ;

val helloWindow = fn () =>

 let
  val shell = XtAppInitialise    ""    "demo" "top" [] [XmNwidth 400, XmNheight 300 ] ;
  val main  = XmCreateMainWindow shell "main" [XmNmappedWhenManaged true ] ;
  val text = XmCreateLabel main "show" [ XmNlabelString "Hello World!"]
 in

  (
  XtManageChildren [text];
  XtManageChild    main;
  XtRealizeWidget  shell
  )

end;
