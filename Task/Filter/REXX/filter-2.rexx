/*REXX program uses a control array to tell which elements ars even.  */
Parse Arg n seed .                /* obtain optional arguments from CL*/
If n==''|n=="," Then n=50         /* Not specified?  use the default  */
If datatype(seed,'W') Then
  Call random,,seed               /* use RANDOM seed for repeatability*/
Do i=1 For n                      /* generate n random numbers        */
  x.i=random(1,99999)             /* generate random number           */
  End
even.=0                           /* all even bits are off            */
Do j=1 To n                       /* process the elements of x.*      */
  If x.j//2==0 Then               /* if element is even, then         */
    even.j=1                      /* turn on the even bit             */
  End
Do k=1 To n                       /* display all the numbers          */
  If even.k Then                  /* that are even                    */
    Say right('x.'k,20) '=' right(x.k,9)
  End
