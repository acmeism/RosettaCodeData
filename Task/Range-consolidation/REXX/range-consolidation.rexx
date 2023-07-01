/*REXX program performs range consolidation (they can be [equal] ascending/descending). */
#.=                                              /*define the default for range sets.   */
parse arg #.1                                    /*obtain optional arguments from the CL*/
if #.1=''  then do                               /*Not specified?  Then use the defaults*/
                #.1= '[1.1, 2.2]'
                #.2= '[6.1, 7.2], [7.2, 8.3]'
                #.3= '[4, 3], [2, 1]'
                #.4= '[4, 3], [2, 1], [-1, -2], [3.9, 10]'
                #.5= '[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]'
                #.6= '[]'
                end

       do j=1  while #.j\=='';   $= #.j          /*process each of the range sets.      */
       say copies('═', 75)                       /*display a fence between range sets.  */
       say '         original ranges:'     $     /*display the original range set.      */
       $= order($)                               /*order low and high ranges; normalize.*/
       call xSort  words($)                      /*sort the ranges using a simple sort. */
       $= merge($)                               /*consolidate the ranges.              */
       say '     consolidated ranges:'     $     /*display the consolidated range set.  */
       end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
merge: procedure expose @.; parse arg y
       if words(y)<2  then signal build          /*Null or only 1 range?  Skip merging. */

          do j=1  to @.0-1;         if @.j==''  then iterate      /*skip deleted ranges.*/
            do k=j+1  to  @.0;      if @.k==''  then iterate      /*  "     "       "   */
            parse var  @.j  a   b;  parse var  @.k  aa  bb        /*extract low and high*/
/*■■■■►*/   if a<=aa & b>=bb  then  do; @.k=;  iterate;            end  /*within a range*/
/*■■■■►*/   if a<=aa & b>=aa  then  do; @.j= a bb; @.k=; iterate;  end  /*abutted ranges*/
            end   /*k*/
          end     /*j*/
build: z=
             do r=1  for @.0;  z= z translate(@.r, ',', " ");  end   /*r*/   /*add comma*/
       f=;   do s=1  for words(z);   f= f '['word(z, s)"], ";  end   /*s*/   /*add [ ], */
       if f==''  then return '[]'                                            /*null set.*/
       return space( changestr(',',  strip( space(f), 'T', ","), ", ") )     /*add blank*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
order: procedure expose @.; parse arg y,,z;  @.= /*obtain arguments from the invocation.*/
       y= space(y, 0)                            /*elide superfluous blanks in the sets.*/
          do k=1  while y\==''  &  y\=='[]'      /*process ranges while range not blank.*/
          y= strip(y, 'L', ",")                  /*elide commas between sets of ranges. */
          parse var  y   '['  L  ","  H  ']'   y /*extract  the "low" and "high" values.*/
          if H<L  then parse value  L H with H L /*order     "    "    "     "      "   */
          L= L / 1;     H= H / 1                 /*normalize the  L  and the  H  values.*/
          @.k= L H;     z= z L','H               /*re─build the set w/o and with commas.*/
          end   /*k*/                            /* [↓]  at this point, K is one to big.*/
       @.0= k - 1                                /*keep track of the number of ranges.  */
       return strip(z)                           /*elide the extra leading blank in set.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
xSort: procedure expose @.; parse arg n          /*a simple sort for small set of ranges*/
          do j=1  to n-1;                        _= @.j
            do k=j+1  to n; if word(@.k,1)>=word(_,1)  then iterate; @.j=@.k; @.k=_; _=@.j
            end   /*k*/
          end     /*j*/;        return
