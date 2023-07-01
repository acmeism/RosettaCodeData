/*REXX compute (and show) combination sets for nt things in ns places*/
  debug=0
  Call time 'R'
  Call RcombN 3,2,'iced,jam,plain'  /* The 1st part of the task      */
  Call RcombN -10,3,'iced,jam,plain,d,e,f,g,h,i,j' /* 2nd part       */
  Call RcombN -10,9,'iced,jam,plain,d,e,f,g,h,i,j' /* extra part     */
  Say time('E') 'seconds'
  Exit
/*-------------------------------------------------------------------*/
Rcombn: Procedure Expose thing. debug
  Parse Arg nt,ns,thinglist
  tell=nt>0
  nt=abs(nt)
  Say '------------' nt 'doughnut selection taken' ns 'at a time:'
  If tell=0 Then
    Say ' list output suppressed'
  Do i=1 By 1 While thinglist>''
    Parse Var thinglist thing.i ',' thinglist /* assign things.      */
    End
  index.=1
  Do cmb=1 By 1
    If tell Then                    /* display combinations          */
      Call show                     /* show this one                 */
    index.ns=index.ns+1
    Call show_index 'A'
    If index.ns==nt+1 Then
      If proc(ns-1) Then
        Leave
    End
  Say '------------' cmb 'combinations.'
  Say
  Return
/*-------------------------------------------------------------------*/
proc: Procedure Expose nt ns thing. index. debug
  Parse Arg recnt
  If recnt>0 Then Do
    p=index.recnt+1
    If p=nt+1 Then
      Return proc(recnt-1)
    Do i=recnt To ns
      index.i=p
      End
    Call show_index 'C'
    End
  Return recnt=0
/*-------------------------------------------------------------------*/
show: Procedure Expose index. thing. ns debug
  l=''
  Call show_index 'B----------------------->'
  Do i=1 To ns
    j=index.i
    l=l thing.j
    End
  Say l
  Return

show_index: Procedure Expose index. ns debug
  If debug Then Do
    Parse Arg tag
      l=tag
      Do i=1 To ns
        l=l index.i
        End
      Say l
    End
  Return
