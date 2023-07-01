/*REXX program determines  if  a list < previous list,   and returns   true  or  false. */
@.=;                    @.1 = 1 2 1 5 2
                        @.2 = 1 2 1 5 2 2
                        @.3 = 1 2 3 4 5
                        @.4 = 1 2 3 4 5
                                                 /* [↓]  compare a list to previous list*/
         do j=2  while  @.j\=='';      p= j - 1  /*P:  points to previous value in list.*/
         if FNorder(@.p, @.j)=='true'  then is= " < "       /*use a more familiar glyph.*/
                                       else is= " ≥ "       /* "  "   "      "      "   */
         say
         say right('['@.p"]", 40)  is  '['@.j"]"
         end   /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
FNorder: procedure;  parse arg x,y
         wx= words(x);     wy= words(y)
                                         do k=1  for min(wx, wy)
                                            a= word(x, k)         /*get a value from X. */
                                            b= word(y, k)         /* "  "   "     "  Y. */
                                         if a<b  then                return 'true'
                                                 else  if a>b  then  return 'false'
                                         end   /*k*/
         if wx<wy  then return 'true'                  /*handle case of equal (so far). */
                        return 'false'                 /*   "     "   "   "     "   "   */
