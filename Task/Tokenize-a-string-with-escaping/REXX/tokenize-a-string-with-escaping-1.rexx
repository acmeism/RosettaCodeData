/*REXX program demonstrates tokenizing and displaying a string with escaping sequences. */
  str = 'one^|uno||three^^^^|four^^^|^cuatro|'   /*the character string to be tokenized.*/
  esc = '^'                                      /* "    escape  character to be used.  */
  sep = '|'                                      /* "  separator     "      "  "   "    */
  out =                                          /* "  output string  (so far).         */
eMode = 0                                        /*a flag,  escape is in progress.      */

  do j=1  for length(str);  _=substr(str, j, 1)  /*parse a single character at a time.  */
  if eMode   then do; out=out || _;  eMode=0;  iterate;  end   /*are we in escape mode? */
  if _==esc  then do;                eMode=1;  iterate;  end   /*is it an escape char ? */
  if _==sep  then do; call show;               iterate;  end   /* "  " a separator char?*/
  out=out || _                                                 /*append the character.  */
  end   /*j*/

if out\=='' | _==sep  then call show             /*handle a residual str or a separator.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  say  '[length'right(length(out),4)"]"   out;             out=;               return
