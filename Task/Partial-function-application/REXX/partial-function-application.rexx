/*REXX program demonstrates a method of partial function application.   */
s=;      do a=0  to 3                  /*build 1st series, low integers.*/
         s=strip(s a)                  /*append to the integer to S list*/
         end   /*a*/

call fs 'f1',s;       say 'for f1:  series=' s",   result=" result
call fs 'f2',s;       say 'for f2:  series=' s",   result=" result

s=;      do b=2  to  8  by 2           /*build 2nd series, low even ints*/
         s=strip(s b)                  /*append to the integer to S list*/
         end   /*b*/

call fs 'f1',s;       say 'for f1:  series=' s",   result=" result
call fs 'f2',s;       say 'for f2:  series=' s",   result=" result
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────F1 subroutine───────────────────────*/
f1:  return arg(1)*2
/*──────────────────────────────────F2 subroutine───────────────────────*/
f2:  return arg(1)**2
/*──────────────────────────────────FS subroutine───────────────────────*/
fs: procedure;  arg f,s;   $=;         do j=1  for words(s);   z=word(s,j)
                                       interpret '$=$'     f"("z')'
                                       end  /*j*/
return strip($)
