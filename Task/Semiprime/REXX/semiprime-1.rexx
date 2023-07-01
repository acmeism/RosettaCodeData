/* REXX ---------------------------------------------------------------
* 20.02.2014 Walter Pachl  relying on 'prime decomposition'
* 21.02.2014 WP Clarification: I copied the algorithm created by
*            Gerard Schildberger under the task referred to above
* 21.02.2014 WP Make sure that factr is not called illegally
*--------------------------------------------------------------------*/
Call test 4
Call test 9
Call test 10
Call test 12
Call test 1679
Exit

test:
Parse Arg z
If is_semiprime(z) Then Say z 'is semiprime' fl
                   Else Say z 'is NOT semiprime' fl
Return

is_semiprime:
  Parse Arg z
  If z<1 | datatype(z,'W')=0 Then Do
    Say 'Argument ('z') must be a natural number (1, 2, 3, ...)'
    fl=''
    End
  Else
    fl=factr(z)
  Return words(fl)=2

/*----------------------------------FACTR subroutine-----------------*/
factr: procedure; parse arg x 1 z,list /*sets X&Z to arg1, LIST=''.  */
if x==1  then return ''             /*handle the special case of X=1.*/
j=2;     call .factr                /*factor for the only even prime.*/
j=3;     call .factr                /*factor for the 1st  odd  prime.*/
j=5;     call .factr                /*factor for the 2nd  odd  prime.*/
j=7;     call .factr                /*factor for the 3rd  odd  prime.*/
j=11;    call .factr                /*factor for the 4th  odd  prime.*/
j=13;    call .factr                /*factor for the 5th  odd  prime.*/
j=17;    call .factr                /*factor for the 6th  odd  prime.*/
                                    /* [?]   could be optimized more.*/
                                    /* [?]   J in loop starts at 17+2*/
     do y=0  by 2;     j=j+2+y//4   /*insure J isn't divisible by 3. */
     if right(j,1)==5  then iterate /*fast check for divisible by 5. */
     if j*j>z          then leave   /*are we higher than the v of Z ?*/
     if j>Z            then leave   /*are we higher than value of Z ?*/
     call .factr                    /*invoke .FACTR for some factors.*/
     end   /*y*/                    /* [?]  only tests up to the v X.*/
                                    /* [?]  LIST has a leading blank.*/
if z==1  then return list           /*if residual=unity, don't append*/
              return list z         /*return list,  append residual. */
/*-------------------------------.FACTR internal subroutine----------*/
.factr:  do  while z//j==0          /*keep dividing until we can't.  */
         list=list j                /*add number to the list  (J).   */
         z=z%j                      /*% (percent)  is integer divide.*/
         end   /*while z··· */      /*  //   ?---remainder integer ÷.*/
return                              /*finished, now return to invoker*/
