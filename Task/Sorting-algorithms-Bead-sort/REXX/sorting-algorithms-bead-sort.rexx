/*REXX program sorts a list (four groups)  of integers  using the  bead sort  algorithm.*/
                                 /* [↓]  define  two dozen  grasshopper  numbers.       */
gHopper= 1 4 10 12 22 26 30 46 54 62 66 78 94 110 126 134 138 158 162 186 190 222 254 270
                                 /* [↓]  these are also called hexagonal pyramidal #s.  */
greenGrocer=  0 4 16 40 80 140 224 336 480 660 880 1144 1456 1820 2240 2720 3264 3876 4560
                                 /* [↓]  define twenty-three Bernoulli numerator numbers*/
bernN= '1 -1 1 0 -1 0 1 0 -1 0 5 0 -691 0 7 0 -3617 0 43867 0 -174611 0'
                                 /* [↓] also called the Reduced Totient function, and is*/
                                 /*also called Carmichael lambda, or the LAMBDA function*/
psi=      1 1 2 2 4 2 6 2 6 4 10 2 12 6 4 4 16 6 18 4 6 10 22 2 20 12 18 6 28 4 30 8 10 16
y= gHopper greenGrocer bernN psi                 /*combine the four lists into one list.*/
call show  'before sort',  y                     /*display the  list  before sorting.   */
say copies('░', 75)                              /*show long separator line before sort.*/
call show  ' after sort',  beadSort(y)           /*display the  list   after sorting.   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
beadSort: procedure; parse arg low . 1 high . 1 z,$;  @.=0 /*$:  the list to be sorted. */
             do j=1  until z=='';   parse var  z   x  z    /*pick the meat off the bone.*/
             x= x / 1;              @.x= @.x + 1           /*normalize X;  bump counter.*/
             low=min(low, x);       high=max(high, x)      /*track lowest and highest #.*/
             end   /*j*/
                                                           /* [↓] now, collect beads and*/
             do m=low  to high;     do @.m;  $=$ m;  end   /*let them fall (to zero).   */
             end   /*m*/
          return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg txt,y;            z=words(y);           w=length(z)
                      do k=1  for z
                      say right('element',30)   right(k,w)   txt":"   right( word(y,k), 9)
                      end   /*k*/;              return
