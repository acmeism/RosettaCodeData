/*REXX program  splits  a (character) string  based on different  separator  delimiters.*/
parse arg $                                      /*obtain optional string from the C.L. */
if $=''   then $= "a!===b=!=c"                   /*None specified?  Then use the default*/
say 'old string:' $                              /*display the old string to the screen.*/
null= '0'x                                       /*null char.   It can be most anything.*/
seps= '== != ='                                  /*list of separator strings to be used.*/
                                                 /* [↓]   process the tokens in  SEPS.  */
  do j=1  for words(seps)                        /*parse the string with all the seps.  */
  sep=word(seps,j)                               /*pick a separator to use in below code*/
                                                 /* [↓]   process characters in the sep.*/
        do k=1  for length(sep)                  /*parse for various separator versions.*/
        sep=strip(insert(null, sep, k), , null)  /*allow imbedded "nulls" in separator, */
        $=changestr(sep, $, null)                /*       ··· but not trailing "nulls". */
                                                 /* [↓]   process strings in the input. */
             do  until $==old;      old=$        /*keep changing until no more changes. */
             $=changestr(null || null, $, null)  /*reduce replicated "nulls" in string. */
             end   /*until*/
                                                 /* [↓]  use  BIF  or  external program.*/
        sep=changestr(null, sep, '')             /*remove true nulls from the separator.*/
        end        /*k*/
  end              /*j*/

showNull= ' {} '                                 /*just one more thing, display the ··· */
$=changestr(null, $, showNull)                   /*        ··· showing of "null" chars. */
say 'new string:' $                              /*now, display the new string to term. */
                                                 /*stick a fork in it,  we're all done. */
