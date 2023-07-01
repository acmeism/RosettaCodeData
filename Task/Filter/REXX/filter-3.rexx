/*REXX program sets all elements containing odd numbers to blank      */
Parse Arg n seed .                /* obtain optional arguments from CL*/
If n==''|n=="," Then n=50         /* Not specified?  use the default  */
If datatype(seed,'W') Then
  Call random,,seed               /* use RANDOM seed for repeatability*/
Do i=1 For n                      /* generate  N  random numbers      */
  x.i=random(1,99999)             /* generate random number           */
  End
Do j=1 To n                       /* process the elements of x.*      */
  If x.j//2<>0 Then               /* if element is not even, then     */
    Drop x.j                      /* delete it                        */
  End
Do k=1 To n                       /* display all the numbers          */
  If datatype(x.k)='NUM' Then     /* that are even                    */
    Say right('x.'k,20) '=' right(x.k,9)
  End
