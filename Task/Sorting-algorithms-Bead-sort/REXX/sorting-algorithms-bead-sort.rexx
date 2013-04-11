/*REXX program sorts a list of integers using a  bead  sort algorithm.  */
             /*get some grassHopper numbers.                            */
grasshopper=,
1 4 10 12 22 26 30 46 54 62 66 78 94 110 126 134 138 158 162 186 190 222 254 270

             /*GreeenGrocer numbers are also called hexagonal pyramidal */
             /*             numbers.                                    */
greengrocer=,
0 4 16 40 80 140 224 336 480 660 880 1144 1456 1820 2240 2720 3264 3876 4560

             /*get some Bernoulli numerator numbers.                    */
bernN='1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617 0 43867 0 -174611 0 854513'

             /*Psi is also called the Reduced Totient function,  and    */
             /*    is also called Carmichale lambda, or LAMBDA function.*/
psi=,
1 1 2 2 4 2 6 2 6 4 10 2 12 6 4 4 16 6 18 4 6 10 22 2 20 12 18 6 28 4 30 8 10 16

list=grasshopper greengrocer bernN psi /*combine the four lists into one*/

call showL 'before sort',list          /*show the list before sorting.  */
$=beadSort(list)                       /*invoke the bead sort.          */
call showL ' after sort',$             /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
beadSort: procedure expose @.; parse arg z
$=                                     /*this'll be the sorted list.    */
low=999999999; high=-low               /*define the low and high numbers*/
@.=0                                   /*define all beads to zero.      */

  do j=1 until z==''                   /*pick the meat off the bone.    */
  parse var z x z
  if \datatype(x,'Whole') then do
                               say; say '*** error! ***'; say
                               say 'element' j "in list isn't numeric:" x
                               say
                               exit 13
                               end
  x=x/1                                /*normalize number, it could be: */
                                       /*     +4   007   5.   2e3   etc.*/
   @.x=@.x+1                           /*indicate this bead has a number*/
   low=min(low,x)                      /*keep track of the lowest number*/
  high=max(high,x)                     /* "     "    "  "  highest   "  */
  end   /*j*/
                                       /*now, collect the beads and     */
  do m=low  to high                    /*let them fall (to zero).       */
  if @.m==0  then iterate              /*No bead here? Then keep looking*/
    do n=1  for @.m                    /*let the beads fall to  0.      */
    $=$ m                              /*add it to the sorted list.     */
    end  /*n*/
  end    /*m*/

return $
/*──────────────────────────────────SHOWL subroutine────────────────────*/
showL: widthH=length(words(arg(2)))    /*maximum width of the index.    */

  do j=1  for words(arg(2))
  say 'element' right(j,widthH) arg(1)":" right(word(arg(2),j),10)
  end   /*j*/

say copies('─',79)                     /*show a separator line.         */
return
