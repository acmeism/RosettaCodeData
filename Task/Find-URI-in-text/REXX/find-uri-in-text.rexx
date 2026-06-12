/*REXX program scans a text (contained within the REXX program) to extract URIs and IRIs*/
$$= 'this URI contains an illegal character, parentheses and a misplaced full stop:',
    'http://en.wikipedia.org/wiki/Erich_Kästner_(camera_designer). (which is handled by http://mediawiki.org/).',
    'and another one just to confuse the parser: http://en.wikipedia.org/wiki/-)',
    '")" is handled the wrong way by the mediawiki parser.',
    'ftp://domain.name/path(balanced_brackets)/foo.html',
    'ftp://domain.name/path(balanced_brackets)/ending.in.dot.',
    'ftp://domain.name/path(unbalanced_brackets/ending.in.dot.',
    'leading junk ftp://domain.name/path/embedded?punct/uation.',
    'leading junk ftp://domain.name/dangling_close_paren)',
    'if you have other interesting URIs for testing, please add them here:'

@abc=        'abcdefghijklmnopqrstuvwxyz'        /*construct lowercase (Latin) alphabet.*/
@abcU= @abc;  upper @abcU;  @abcs= @abc || @abcU /*    "     lower & uppercase     "    */
@scheme=     @abcs || 0123456789 || '+-.'        /*add decimal digits & some punctuation*/
@unreserved= @abcs || 0123456789 || '-._~'       /* "     "      "    "   "       "     */
@reserved=   @unreserved"/?#[]@!$&)(*+,;=\'"     /*add other punctuation & special chars*/
$= space($$)' '                                  /*variable  $  is a working copy of $$ */
#= 0                                             /*the count of  URI's  found  (so far).*/
                                                 /*▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄*/
  do  while  $\='';            y= pos(':', $)    /*locate a colon  (:) in the text body.*/
  if y==0  then leave                            /*Was a colon found?  Nope, we're done.*/
  if y==1  then do;    parse var   $   .  $      /*handle a  bare colon  by itself.     */
                       iterate                   /*go and keep scanning for a colon.    */
                end                              /* [↑]   (a rare special case.)        */
  sr= reverse( left($, y - 1) )                  /*extract the  scheme  and reverse it. */
  se= verify(sr, @scheme)                        /*locate the  end  of the  scheme.     */
  $= substr($, y + 1)                            /*assign an adjusted new text.         */
  if se\==0  then sr= left(sr, se - 1)           /*possibly  "crop"  the  scheme  name. */
  s= reverse(sr)                                 /*reverse it again to rectify the name.*/
  he= verify($, @reserved)                       /*locate the end of  hierarchical part.*/
  s= s':'left($, he - 1)                         /*extract and append      "         "  */
  $=   substr($, he)                             /*assign an adjusted new part of text. */
  #= # + 1                                       /*bump the  URI  counter.              */
  !.#= s                                         /*assign the  URI  to an array  (!.)   */
  end   /*while*/                                /* [↑]  scan the text for URI's.       */
                                                 /*▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀*/
 do k=1  for #;     say !.k;      end            /*stick a fork in it,  we're all done. */
