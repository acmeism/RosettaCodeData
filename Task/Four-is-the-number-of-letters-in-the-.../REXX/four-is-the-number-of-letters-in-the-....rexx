/*REXX pgm finds/shows the number of letters in the  Nth  word in a constructed sentence*/
@= 'Four is the number of letters in the first word of this sentence,'             /*···*/
                                                 /* [↑]   the start of a long sentence. */
parse arg N M                                    /*obtain optional argument from the CL.*/
if N='' | N="," then N= 201                      /*Not specified?  Then use the default.*/
if M='' | M="," then M=1000 10000 100000 1000000 /* "      "         "   "   "     "    */
@abcU= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'              /*define the uppercase Latin alphabet. */
!.=.;     #.=.;      q=1;       w=length(N)      /* [↓]  define some helpful low values.*/
call tell N
if N<0  then say y     ' is the length of word '         a          "  ["word(@, a)"]"
say                                              /* [↑]  N negative?  Just show 1 number*/
say 'length of sentence= '   length(@)           /*display the length of the @ sentence.*/

if M\==''  then do k=1  for words(M)  while M\=0 /*maybe handle counts  (if specified). */
                x=word(M, k)                     /*obtain the  Kth  word of the M list. */
                call tell  -x                    /*invoke subroutine (with negative arg)*/
                say
                say y     ' is the length of word '      x       "  ["word(@, x)"]"
                say 'length of sentence= '  length(@)    /*display length of @ sentence.*/
                end   /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
wordLen: arg ?;         return length(?) - length( space( translate(?, , @abcU), 0) )
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: parse arg z,,$;   idx=1;    a=abs(z);     group=25     /*show 25 numbers per line.*/
                                                 /*Q is the last number spelt by $SPELL#*/
        do j=1  for a                            /*traipse through all the numbers to N.*/
          do 2                                   /*perform loop twice  (well ··· maybe).*/
          y=wordLen( word(@, j) )                /*get the  Jth  word from the sentence.*/
          if y\==0  then leave                   /*Is the word spelt?   Then we're done.*/
          q=q + 1                                /*bump the on─going (moving) # counter.*/
          if #.q==.  then #.q=$spell#(q 'Q ORD') /*need to spell A as an ordinal number?*/
               _=wordLen( word(@, q) )           /*use the length of the ordinal number.*/
          if !._==.  then !._=$spell#(_ 'Q')     /*Not spelled?   Then go and spell it. */
          @=@  !._   'in the'    #.q","          /*append words to never─ending sentence*/
          end   /*2*/                            /* [↑]   Q ≡ Quiet      ORD ≡ ORDinal  */

        $=$ || right(y, 3)                       /* [↓]  append a justified # to a line.*/
        if j//group==0 & z>0  then do; say right(idx, w)'►'$;   idx=idx+group;   $=;   end
        end   /*j*/                              /* [↑]  show line if there's enough #s.*/

      if $\=='' & z>0 then say right(idx, w)'►'$ /*display if there are residual numbers*/
      return
