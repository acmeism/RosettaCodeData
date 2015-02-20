/*REXX program displays  eight (or a specified range of) happy  numbers.*/
parse arg L H .                        /*get optional args:  low & high */
if L=='' | L==',' then L=8             /*Not specified? Set L to default*/
if H=='' | H==',' then do; H=L; L=1; end  /*use a range for the showing.*/
#.0=0; #.1=1; #.2=4; #.3=9; #.4=16; #.5=25; #.6=36; #.7=49; #.8=64; #.9=81
@.=0; @.1=1; !.=@.; !.2=1; !.3=1; !.4=1   /*sparse array: @≡hap, !≡unhap*/
haps=0                                 /*count of happy numbers so far. */

    do n=1  while haps<H               /*search integers starting at  1.*/
    if !.n  then iterate               /*if  N  is unhappy, try another.*/
    q=n                                /*(below) Q is the number tested.*/
            do  until q==1;  s=0       /*see if  Q  is a happy number.  */
            ?=q                        /*note: ? is destructively PARSEd*/
                 do length(q)          /*parse all digs of ?  (base 10).*/
                 parse var  ?  _  +1 ? /*obtain a  single  digit of   ? */
                 s=s + #._             /*add the square  of  that digit.*/
                 end   /*length(q)*/   /* [↑]  perform the DO  W  times.*/

            if !.s  then iterate n     /*Sum unhappy?  Then Q is unhappy*/
            if @.s  then leave         /*we have found a  happy  number.*/
            q=s                        /*try the  Q sum to see if happy.*/
            end   /*until*/
    @.n=1                              /*mark   N   as a  happy number. */
    haps=haps+1                        /*bump the count of happy numbers*/
    if haps<L  then iterate            /*don't display,  N  is too low. */
    say  right(n, 30)                  /*display right justified happy #*/
    end     /*n*/
                                       /*stick a fork in it, we're done.*/
