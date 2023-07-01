/*REXX pgm solves a puzzle:  using the string 123456789, insert  -  or  +  to sum to 100*/
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO=       100          /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI=        LO          /* "      "         "   "   "     "    */
if LO==00            then HI= 123456789          /*LOW specified as zero with leading 0.*/
ops= '+-';             L= length(ops) + 1        /*define operators (and their length). */
@.=;      do i=1  for L-1;  @.i= substr(ops,i,1) /*   "   some handy-dandy REXX literals*/
          end   /*i*/                            /*   "   individual operators for speed*/
mx= 0;  mn= 999999                               /*initialize the minimums and maximums.*/
mxL=;   mnL=;         do j=LO  to HI  until LO==00  &  mn==0  /*solve with range of sums*/
                      z= ???(j)                               /*find # solutions for J. */
                      if z> mx  then     mxL=                 /*is this a new maximum ? */
                      if z>=mx  then do; mxL=mxL j; mx=z; end /*remember this new max.  */
                      if z< mn  then     mnL=                 /*is this a new minimum ? */
                      if z<=mn  then do; mnL=mnL j; mn=z; end /*remember this new min.  */
                      end   /*j*/
if LO==HI  then exit 0                                        /*don't display max&min ? */
@@= 'number of solutions: ';   say
_= words(mxL);  say 'sum's(_)   "of"   mxL  ' 's(_,"have",'has')   'the maximum'   @@   mx
_= words(mnL);  say 'sum's(_)   "of"   mnL  ' 's(_,"have",'has')   'the minimum'   @@   mn
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:   if arg(1)==1  then return arg(3);   return word( arg(2) "s",1)  /*simple pluralizer*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
???: parse arg answer;          #= 0             /*obtain the answer (sum) to the puzzle*/
       do         a=L-1  for 2; aa=       @.a'1' /*choose one  of  -       or  nothing. */
        do        b=1  for L;   bb= aa || @.b'2' /*   "    "    "  -   +,  or  abutment.*/
         do       c=1  for L;   cc= bb || @.c'3' /*   "    "    "  "   "    "      "    */
          do      d=1  for L;   dd= cc || @.d'4' /*   "    "    "  "   "    "      "    */
           do     e=1  for L;   ee= dd || @.e'5' /*   "    "    "  "   "    "      "    */
            do    f=1  for L;   ff= ee || @.f'6' /*   "    "    "  "   "    "      "    */
             do   g=1  for L;   gg= ff || @.g'7' /*   "    "    "  "   "    "      "    */
              do  h=1  for L;   hh= gg || @.h'8' /*   "    "    "  "   "    "      "    */
               do i=1  for L;   ii= hh || @.i'9' /*   "    "    "  "   "    "      "    */
               interpret '$='   ii               /*calculate the sum of modified string.*/
               if $\==answer  then iterate       /*Is sum not equal to answer? Then skip*/
               #= # + 1;        if LO==HI  then say 'solution: '    $    " ◄───► "    ii
               end   /*i*/                       /*                                     */
              end    /*h*/                       /*                          d          */
             end     /*g*/                       /*                          d          */
            end      /*f*/                       /*   eeeee   n nnnn    dddddd   sssss  */
           end       /*e*/                       /*  e     e  nn    n  d     d  s       */
          end        /*d*/                       /*  eeeeeee  n     n  d     d   sssss  */
         end         /*c*/                       /*  e        n     n  d     d        s */
        end          /*b*/                       /*   eeeee   n     n   ddddd    sssss  */
       end           /*a*/                       /*                                     */
     y= #                                        /* [↓]  adjust the number of solutions?*/
     if y==0  then y= 'no'                       /* [↓]  left justify plural of solution*/
     if LO\==00  then say right(y, 9)          'solution's(#, , " ")     'found for'  ,
                          right(j, length(HI) )                           left('', #, "─")
     return #                                    /*return the number of solutions found.*/
