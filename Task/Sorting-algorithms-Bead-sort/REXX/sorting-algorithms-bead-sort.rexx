/*REXX program  sorts  a  list of integers  using the  bead sort  algorithm.            */
grasshopper=,                                    /*define two dozen grasshopper numbers.*/
          1 4 10 12 22 26 30 46 54 62 66 78 94 110 126 134 138 158 162 186 190 222 254 270

                   /*Green Grocer numbers are also called  hexagonal pyramidal  numbers.*/
greenGrocer=  0 4 16 40 80 140 224 336 480 660 880 1144 1456 1820 2240 2720 3264 3876 4560

                                                 /*define 23 Bernoulli numerator numbers*/
bernN= '1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617 0 43867 0 -174611 0 854513'

                               /*Psi is also called the Reduced Totient function, and is*/
psi=,                          /*also called Carmichael lambda,  or the LAMBDA function.*/
          1 1 2 2 4 2 6 2 6 4 10 2 12 6 4 4 16 6 18 4 6 10 22 2 20 12 18 6 28 4 30 8 10 16

#= grasshopper greenGrocer bernN psi             /*combine the four lists into one list.*/
call show  'before sort',  #                     /*display the  list  before sorting.   */
call show  ' after sort',  beadSort(#)           /*   "     "     "    after    "       */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
beadSort: procedure;  parse arg low . 1 high . 1 z,$       /*$:  the list to be sorted. */
          @.=0                                             /*set all beads (@.) to zero.*/
               do j=1  until z=='';   parse var z x z      /*pick the meat off the bone.*/
               if \datatype(x, 'W')  then do;   say  '***error***'
                                          say 'element'   j   "in list isn't numeric:"  x
                                          say;  exit 13
                                          end              /* [↑]  exit pgm with RC=13. */
               x=x/1                                       /*normalize:  4. 004 +4 .4e0 */
               @.x=@.x+1                                   /*indicate this bead has a #.*/
               low=min(low,x);   high=max(high,x)          /*track lowest and highest #.*/
               end   /*j*/
                                                           /* [↓] now, collect beads and*/
               do m=low  to high                           /*let them fall (to zero).   */
               if @.m\==0  then  do n=1  for @.m;   $=$ m  /*have we found a bead here? */
                                 end   /*n*/               /* [↑]  add it to sorted list*/
               end   /*m*/

          return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg txt,y;                               _=left('', 20)
      w=length(words(y));   do k=1  for words(y)           /*  [↑]   twenty pad blanks. */
                            say _  'element'   right(k, w)   txt":"   right(word(y, k), 9)
                            end   /*k*/
      say copies('─', 70)                                  /*show a long separator line.*/
      return
