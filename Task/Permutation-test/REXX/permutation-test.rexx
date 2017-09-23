/*REXX program  performs a    permutation test   on     N + M   subjects  (volunteers): */
                                                 /*     ↑   ↑                           */
                                                 /*     │   │                           */
                                                 /*     │   └─────control  population.  */
                                                 /*     └────────treatment population.  */
n=9
data= 85 88 75 66 25 29 83 39 97         68 41 10 49 16 65 32 92 28 98
w=words(data);       m=w-n
say 'w=' w
say 'volunteer population given treatment:'        right(n, length(w) )
say ' control  population given a placebo:'        right(m, length(w) )
say
say 'treatment population efficacy % (percentages):'        subword(data, 1, n)
say ' control  population placebo  % (percentages):'        subword(data, n+1 )
say
                     do v=  0  for w         ;     #.v=word(data, v+1) ;       end
treat=0;             do i=  0  to n-1        ;     treat=treat + #.i   ;       end
  tot=1;             do j=  w  to m+1  by -1 ;     tot=tot * j         ;       end
                     do k=w%2  to  1   by -1 ;     tot=tot / k         ;       end

GT=picker(n+m, n, 0)                             /*compute the GT value from PICKER func*/
LE=tot - GT                                      /*   "     "  LE   "   via subtraction.*/
say "<= "  format(100 * LE / tot, ,3)'%'   LE    /*display number with 3 decimal places.*/
say " > "  format(100 * GT / tot, ,3)'%'   GT    /*   "       "     "  "    "       "   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
picker:  procedure expose #. treat;                parse arg it,rest,eff     /*get args.*/
         if rest==0  then return   eff > treat                               /*Zero ?   */
         if it>rest  then q=picker(it-1, rest, eff)                          /*recurse. */
                     else q=0
         itP=it - 1                                                          /*temp var.*/
         return picker(itP,  rest - 1,  eff+#.itP)  +  q                     /*recurse. */
