/*REXX program  computes and displays a  specified range  of  happy  numbers. */
sw=linesize()                          /*obtain the screen width of terminal. */
parse arg L H .                        /*get optional arguments from the C.L. */
if L=='' | L==',' then L=8             /*Not specified?  Then use the default.*/
if H=='' | H==',' then do;H=L;L=1; end /*use a range for the displaying of #s.*/
    do i=0 to 9; #.i=i**2; end  /*i*/  /*build a squared decimal digit table. */
@.=0;  @.1=1;    !.=@.;  !.2=1;  !.4=1 /*sparse array:   @≡happy,  !≡unhappy. */
haps=0                                 /*count of the happy numbers  (so far).*/
$=
    do n=1  while haps<H               /*search integers starting at  unity.  */
    if !.n  then iterate               /*if  N  is unhappy, then try another. */
    q=n                                /*(below)  Q  is the number tested.    */
            do  until q==1;  s=0       /*see if   Q  is a happy number.       */
            ?=q                        /* [↓]    ?  is destructively PARSEd.  */
                 do length(q)          /*parse all the    decimal digits of ? */
                 parse var  ?  _  +1 ? /*obtain a  single decimal digit  of ? */
                 s=s + #._             /*add the square of that decimal digit.*/
                 end   /*length(q)*/   /* [↑]  perform the   DO    W   times. */

            if !.s  then do; !.n=1; iterate n; end   /*S unhappy? Then Q also.*/
            if @.s  then leave         /*Have we found a  happy  number?      */
            q=s                        /*try the  Q  sum to see if it's happy.*/
            end   /*until*/
    @.n=1                              /*mark     N     as a   happy number.  */
    haps=haps+1                        /*bump the count of the happy numbers. */
    if haps<L  then iterate            /*don't display it,   N   is too low.  */
    $=$ n                              /*add   N   to the horizontal list.    */
    if length($ n)>sw  then do         /*if the list is too long, then split  */
                            say strip($)    /*··· and display what we've got. */
                            $=n             /*Set the next line to overflow.  */
                            end             /* [↑]  now contains overflow.    */
    end     /*n*/
if $\=''  then say strip($)            /*display any residual happy numbers.  */
                                       /*stick a fork in it,  we're all done. */
