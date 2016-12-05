/*REXX program   computes  and  displays   a specified  range  of   happy   numbers.    */
parse arg L H .                                  /*obtain optional arguments from the CL*/
if L=='' | L==","  then L=8                      /*Not specified?  Then use the default.*/
if H=='' | H==","  then do;  H=L; L=1;  end      /*use a range for the displaying of #s.*/
            do i=0  to 9;  #.i=i**2;  end /*i*/  /*build a squared decimal digit table. */
@.=0;   @.1=1;       !.=@.;    !.2=1;    !.4=1   /*sparse array:   @≡happy,  !≡unhappy. */
haps=0                                           /*count of the happy numbers  (so far).*/

    do n=1  while  haps<H                        /*search integers starting at unity.   */
    if !.n  then iterate                         /*if  N  is unhappy, then try another. */
    q=n                                          /* [↓]    Q  is the number being tested*/
          do  until q==1;    s=0                 /*see if  Q  is a  happy number.       */
          ?=q                                    /* [↓]    ?  is destructively parsed.  */
               do length(q)                      /*parse all the    decimal digits of ? */
               parse var  ?  _  +1 ?             /*obtain a  single decimal digit  of ? */
               s=s + #._                         /*add the square of that decimal digit.*/
               end   /*length(q)*/               /* [↑]  perform the    DO    W  times. */
          if !.s  then do; !.n=1; iterate n; end /*is  S  unhappy?    Then  Q  is also. */
          if @.s  then leave                     /*Have we found a  happy  number?      */
          q=s                                    /*try the  Q  sum to see if it's happy.*/
          end   /*until*/
    @.n=1                                        /*mark      N      as a   happy number.*/
    haps=haps+1                                  /*bump the counter of the happy numbers*/
    if haps<L  then iterate                      /*don't display  if    N    is too low.*/
    say  right(n, 30)                            /*display right justified happy number.*/
    end        /*n*/
                                                 /*stick a fork in it,  we're all done. */
