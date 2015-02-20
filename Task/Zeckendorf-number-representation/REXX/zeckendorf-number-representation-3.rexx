/*REXX pgm calculates and displays the first   N   Zeckendorf  numbers. */
numeric digits 1000                    /*just in case user gets ka─razy.*/
parse arg n .;   if n==''  then n=20   /*let user specify upper limit.  */
z=0                                    /*index of a  Zeckendorf number. */
    do j=0  until z>n;  _=x2b(d2x(j))  /*task: process zero  ──►   N.   */
    if pos(11,_)\==0  then iterate     /*two consecutive ones (1s) ?    */
    say '    Zeckendorf' right(z,length(n)) '= ' right(_+0,30) /*show #.*/
    z=z+1                              /*bump the Zeckendorf #  counter.*/
    end   /*j*/                        /* [↑] compute/show Zeckendorf #s*/
                                       /*stick a fork in it, we're done.*/
