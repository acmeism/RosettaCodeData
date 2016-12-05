/*REXX compute (and show) combination sets for nt things in ns places*/
  Numeric Digits 20
  debug=0
  Call time 'R'
  Call IcombN 3,2,'iced,jam,plain'  /* The 1st part of the task      */
  Call IcombN -10,3,'iced,jam,plain,d,e,f,g,h,i,j' /* 2nd part       */
  Call IcombN -10,9,'iced,jam,plain,d,e,f,g,h,i,j' /* extra part     */
  Say time('E') 'seconds'
  Exit

IcombN: Procedure Expose thing. debug
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
  cmb=0
  Call show
  i=ns+1
  Do While i>1
    i=i-1
    Do j=1 By 1 While index.i<nt
      index.i=index.i+1
      Call show
      End
    i1=i-1
    If index.i1<nt Then Do
      index.i1=index.i1+1
      Do ii=i To ns
        index.ii=index.i1
        End
      Call show
      i=ns+1
      End
    If index.1=nt Then Leave
    End
  Say cmb
  Return

show: Procedure Expose ns index. thing. tell cmb
  cmb=cmb+1
  If tell Then Do
    l=''
    Do i=1 To ns
      j=index.i
      l=l thing.j
      End
    Say l
    End
  Return
