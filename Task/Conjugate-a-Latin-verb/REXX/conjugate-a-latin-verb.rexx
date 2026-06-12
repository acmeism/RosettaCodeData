/*REXX pgm conjugates (to the terminal) a Latin verb when given a first conjugation verb*/
parse arg verbs
if verbs='' | verbs=","  then verbs= 'amare dare'
suffix= 'o as at amus atis ant'                  /*a list of six Latin verb suffixes.   */
#= words(verbs)                                  /*obtain the # of Latin verbs specified*/

      do j=1  for #;                  say        /*process each      "     "       "    */
      $= word(verbs, j);  $$= $;      upper $$   /*obtain one of the "     "       "    */
      if \datatype($, 'M')  then call ser "the following isn't a Latin verb: "      $
      L= length($)                               /*obtain the length of a Latin verb.   */
      if L<4  then call ser 'length of Latin verb is too short: '     $
      if right($$, 3)\=='ARE'  then call ser "the following isn't a Latin verb: "   $
      stem= left($, length($) - 3)               /*obtain the stem of the Latin verb.   */
      say center(' present indicative tense of "'$'"', 50, "─")

         do k=1  for words(suffix)               /*display each of the verb suffixes.   */
         say left('',21) stem || word(suffix, k) /*display a Latin verb stem with auffix*/
         end   /*k*/
      say
      end      /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser:  say;   say '***error*** '  arg(1);   say;   exit 13
