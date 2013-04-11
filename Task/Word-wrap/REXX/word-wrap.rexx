/*REXX program justifies (by words) a string of words ───► screen.      */
arg justify width .                    /*───────────JUSTIFY─────────────*/
                                       /*Center:       ◄centered►       */
                                       /*  Both:   ◄──both margins──►   */
                                       /* Right:  ────────►right margin */
                                       /*  Left:   left margin◄──────── */
                                       /*═════pick one of the above.════*/

just=left(justify,1)                   /*only use first capital letter. */

if width=='' then width=linesize()%2   /*It's null?  Then pick a default*/
if width==0  then width=40             /*Not determinable?  Then use 40.*/

txt="Diplomacy is the art of saying 'Nice Doggy' until",
    "you can find a rock.             ─── Will Rodgers"

$=''                                   /*this is where the money is.    */

  do k=1 for words(txt); x=word(txt,k) /*parse 'til we exhaust the TXT. */
  _=$ x                                /*append it to da money and see. */
  if length(_)►width then call tell    /*word(s) exceeded the width?    */
  $=_                                  /*the new words are OK so far.   */
  end

call tell                              /*handle any residual words.     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: if $=='' then return             /*first word may be too long.    */
             select
             when just=='B' then $=justify($,width)     /*◄────both────►*/
             when just=='C' then $= center($,width)     /*  ◄centered►  */
             when just=='R' then $=  right($,width)     /*──────► right */
             otherwise           $=  strip($)           /*left ◄────────*/
             end   /*select*/
      say $                            /*show and tell, or write──►file?*/
      _=x                              /*handle any word overflow.      */
      return                           /*go back and keep truckin'.     */
