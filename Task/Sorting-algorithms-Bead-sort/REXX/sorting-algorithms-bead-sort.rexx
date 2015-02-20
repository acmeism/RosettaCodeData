/*REXX program sorts a  list of integers  using a  bead sort  algorithm.*/
grasshopper=,                          /*get 2 dozen grasshopper numbers*/
1 4 10 12 22 26 30 46 54 62 66 78 94 110 126 134 138 158 162 186 190 222 254 270

                                       /*Green Grocer numbers are also  */
greenGrocer=,                          /*called hexagonal pyramidal nums*/
0 4 16 40 80 140 224 336 480 660 880 1144 1456 1820 2240 2720 3264 3876 4560

                                       /*get 23 Bernoulli numerator nums*/
bernN='1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617 0 43867 0 -174611 0 854513'

               /*Psi is also called the Reduced Totient function, and is*/
psi=,          /*also called Carmichale lambda,  or the LAMBDA function.*/
1 1 2 2 4 2 6 2 6 4 10 2 12 6 4 4 16 6 18 4 6 10 22 2 20 12 18 6 28 4 30 8 10 16

#s=grasshopper greenGrocer bernN psi   /*combine the four lists into one*/
call show 'before sort', #s            /*show the  list  before sorting.*/
call show ' after sort', beadSort(#s)  /*show the  list   after sorting.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
beadSort: procedure; parse arg low . 1 high . 1 z,$  /*$: the list to be*/
@.=0                                   /*set all beads  (@.)  to zero.  */
     do j=1  until z==''; parse var z x z  /*pick the meat off the bone.*/
     if \datatype(x,'W')  then do;  say  '*** error! ***'
                               say 'element' j "in list isn't numeric:"  x
                               say;            exit 13
                               end     /* [↑]  exit program with RC=13. */
     x=x/1                             /*normalize X: 4. 004 +4 .4e0 ···*/
     @.x=@.x+1                         /*indicate this bead has a number*/
     low=min(low,x);  high=max(high,x) /*track the lowest & highest num.*/
     end   /*j*/
                                       /* [↓] now, collect the beads and*/
  do m=low  to high                    /*let them fall (to zero).       */
  if @.m\==0  then  do n=1  for @.m    /*have we found a bead here?     */
                    $=$ m              /*add it to the sorted list.     */
                    end   /*n*/        /* [↑]  let beads fall to zero.  */
  end  /*m*/

return $
/*──────────────────────────────────SHOW subroutine─────────────────────*/
show: parse arg txt,y;                               _=left('', 20)
w=length(words(y));   do k=1  for words(y)       /* [↑]   twenty blanks.*/
                      say _ 'element' right(k,w) txt":" right(word(y,k),9)
                      end   /*k*/
say copies('─',70)                     /*show a long separator line.    */
return
