open XWindows ;
open Motif ;

val countWindow = fn () =>

 let
  val ctr   =  ref 0;
  val shell =  XtAppInitialise     ""    "demo" "top" [] [XmNwidth 300, XmNheight 150 ] ;
  val main  =  XmCreateMainWindow  shell    "main"       [XmNmappedWhenManaged true ] ;
  val frame =  XmCreateForm        main     "frame"      [XmNwidth 390, XmNheight 290 ] ;
  val text  =  XmCreateLabel       frame    "show"       [XmNlabelString "No clicks yet" ] ;
  val buttn =  XmCreateDrawnButton frame    "press"      [XmNwidth 75 , XmNheight 30 ,
                                            XmNlabelString "Click me" ,
                                            XmNbottomAttachment XmATTACH_POSITION,XmNbottomPosition 98 ] ;
  val report = fn (w,c,t)  =>
     (XtSetValues text [XmNlabelString (Int.toString (ctr:= !ctr +1; !ctr)) ] ; t )
 in

  (
   XtSetCallbacks   buttn      [ (XmNactivateCallback , report) ] XmNarmCallback ;
   XtManageChildren [ text,buttn ] ;
   XtManageChildren [ frame ] ;
   XtManageChild    main ;
   XtRealizeWidget  shell
  )

end;
