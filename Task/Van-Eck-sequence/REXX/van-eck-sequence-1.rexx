/*REXX pgm generates/displays the 'start --> end' elements of the Van Eck sequence.*/
Parse Arg lo hi d .                         /*obtain optional arguments from the CL*/
If lo=='' | lo==','  Then lo=   1           /*Not specified?  Then use the default.*/
If hi=='' | hi==','  Then hi=  10           /* "      "         "   "   "     "    */
If  d=='' |  d==','  Then  d=   0           /* "      "         "   "   "     "    */
dd=''
z=d                                         /*dd: old seq:  d: initial value of seq*/
Do i=1 To hi-1
  za=wordpos(reverse(z),reverse(dd))
  zb=0
  wdd=words(dd)
  Do zz=wdd To 1 By -1
    If z=word(dd,zz) Then Do
      zb=wdd-zz+1
      Leave
      End
    End
  z=za
  dd=d
  d=d z
  End   /*HI-1*/                            /*REVERSE allows backwards search in d.*/
Say 'terms ' lo ' through ' hi ' of the Van Eck sequence are: ' subword(d,lo,hi-lo+1)
Exit
                              /*stick a fork in it,  we're all done. */
