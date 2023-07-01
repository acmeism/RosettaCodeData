 /* REXX **************************************************************
 * 25.08.2013 Walter Pachl derived from PL/I
 *********************************************************************/
 mm=0
 w.=''
 l.=0
 Call mkset 1,'the that a if'
 Call mkset 2,'frog elephant thing'
 Call mkset 3,'walked treaded grows trots'
 Call mkset 4,'slowly quickly'

 Call show
 Do i=1 to 3                           /* loop over sets             */
   Call showm
   k=i+1                               /* the following set          */
   Do ii=1 To 10                       /* loop over elements in set k*/
     If words(w.i.ii)=i Then Do        /* a sentence part found      */
       Do jj=1 To 10                   /* loop over following words  */
         If right(w.i.ii,1)=left(w.k.jj,1) Then Do  /* fitting       */
           ns=w.i.ii' 'w.k.jj          /* build new sentence (part)  */
           If words(ns)=k Then         /* 'complete' part            */
             Call add k,ns             /* add to set k               */
           End
         End
       End
     End
   End

 Do jj=1 To 10                         /* show the results           */
   If words(w.4.jj)=4 Then
     Say '-->' w.4.jj
   End
 Return

 add: Procedure Expose w.
 /*********************************************************************
 * add a sentence (part) to set ni
 *********************************************************************/
   Parse Arg ni,s
   Do i=1 To 10 While w.ni.i>''        /* look for an empty slot     */
     End
   w.ni.i=s                            /* add the sentence (part)    */
   Return

 mkset: Procedure Expose w. mm l.
 /*********************************************************************
 * initialize the sets
 *********************************************************************/
   Parse Arg i,wl
   Do j=1 By 1 While wl<>''
     Parse Var wl w.i.j wl
     l.i=max(l.i,length(w.i.j))
     End
   mm=max(mm,j-1)
   Return

show: Procedure Expose w. mm l.
 /*********************************************************************
 * show the input
 *********************************************************************/
 Say 'Input:'
 Do j=1 To mm                          /* output lines               */
   ol=''
   Do i=1 To 4
     ol=ol left(w.i.j,l.i)
     End
   Say strip(ol)
   End;
 say ''
 Return

showm: Procedure Expose w.
 /*********************************************************************
 * show the sets' contents
 *********************************************************************/
  dbg=0
  If dbg Then Do
    Do i=1 To 4
      Do j=1 To 10
        If w.i.j>'' Then
          Say i j w.i.j
        End
      End
    End
  Return
