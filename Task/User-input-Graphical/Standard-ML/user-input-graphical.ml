open XWindows ;
open Motif ;

val store : string list ref = ref [] ;

val inputWindow = fn () =>
let
  val shell  =  XtAppInitialise      ""    "demo" "top" [] [ XmNwidth 320, XmNheight 100 ] ;
  val main   =  XmCreateMainWindow   shell    "main"       [ XmNmappedWhenManaged true   ] ;
  val enter  =  XmCreateText         main   "inputarea"    [ XmNeditMode XmSINGLE_LINE_EDIT,
                                                             XmNscrollHorizontal false   ] ;
  val getinp =  fn (w,s,t) => ( store := XmTextGetString enter :: !store   ; t )
in

  (
   XtSetCallbacks   enter [ (XmNactivateCallback , getinp) ] XmNarmCallback ;
   XtManageChild    enter ;
   XtManageChild    main  ;
   XtRealizeWidget  shell
  )

end ;

inputWindow () ;
