/*REXX pgm displays N tau numbers (integers divisible by the # of its divisors).  */
Parse Arg n cols .                        /*obtain optional argument from the CL. */
If    n=='' |    n==','  Then    n= 100   /*Not specified?  Then use the default. */
If cols=='' | cols==','  Then cols=  10   /*Not specified?  Then use the default. */
w=6                                       /*W:  used To align 1st output column.  */
ttau=' the first ' commas(n) ' tau numbers' /* the title of the table.            */
Say ' index ¦'center(ttau,cols*(w+1)     )  /* display the title                  */
Say '-------+'center(''  ,cols*(w+1),'-')
idx=1
nn=0                                      /* number of tau numbers                */
dd=''
Do j=1  Until nn==n                       /* search for   N   tau numbers         */
  If j//tau(j)==0 Then Do                 /* If this is a tau number              */
    nn=nn+1                               /* bump the count of tau numbers found. */
    dd=dd right(commas(j),w)              /* add a tau number To the output list. */
    If nn//cols==0 Then Do                /* a line is full                       */
      Say center(idx,7)'¦' substr(dd,2)   /* display partial list To the terminal.*/
      idx= idx+cols                       /* bump idx by number of cols           */
      dd=''
      End
    End
  End
If dd\=='' Then Say center(idx,7)'¦' substr(dd,2) /*possible display rest         */
Say '--------'center(''  ,cols*(w+1),'-')
Exit 0                                    /*stick a fork in it,we're all done.    */
/*--------------------------------------------------------------------------------*/
commas: Parse Arg ?; Do jc=length(?)-3 To 1 by -3; ?=insert(',',?,jc); End; Return ?
/*--------------------------------------------------------------------------------*/
tau: Procedure
  Parse Arg x
  If x<6 Then                              /* some low numbers are handled special */
    Return 2+(x==4)-(x==1)
  tau=0
  odd=x//2
  Do j=1 by 1 While j*j<x
    If odd & j//2=0 Then                   /* even j can't be a divisor of an odd x*/
      Iterate
    If x//j==0  Then                       /* If no remainder,Then found a divisor*/
      tau=tau+2                            /* bump n of divisors                   */
    End
  If j*j=x Then                            /* x is a square                        */
    tau=tau+1                              /* its root is a divisor                */
  Return tau
