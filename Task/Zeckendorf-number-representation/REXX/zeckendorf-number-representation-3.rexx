/*REXX program calculates and displays the first   N   Zeckendorf numbers.    */
numeric digits 100000                  /*just in case user gets real ka─razy. */
parse arg N .;    if N==''  then n=20  /*let user specify the upper limit.    */
z=0                                    /*the index of a  Zeckendorf number.   */
    do j=0  until z>N;  _=x2b(d2x(j))  /*task: process zero  ──►   N.         */
    if pos(11,_)\==0  then iterate     /*are there two consecutive ones (1s) ?*/
    say '    Zeckendorf'  right(z,length(N))  '= '  right(_+0,30)     /*show #*/
    z=z+1                              /*bump the  Zeckendorf  number counter.*/
    end   /*j*/                        /* [↑]  compute/display Zeckendorf #s. */
                                       /*stick a fork in it,  we're all done. */
