/*REXX program to demonstrate various uses and types of comments. */

/* everything between a "climbstar" and a "starclimb" (exclusive of literals) is
   a comment.
                         climbstar =  /*   [slash-asterisk]
                         starclimb =  */   [asterisk-slash]

            /* this is a nested comment, by gum! */
            /*so is this*/

Also, REXX comments can span multiple records.

There can be no intervening character between the slash and asterisk  (or
the asterisk and slash).  These two joined characters cannot be separated
via a continued line, as in the manner of:

       say 'If I were two─faced,' ,
           'would I be wearing this one?' ,
           '      --- Abraham Lincoln'

 Here comes the thingy that ends this REXX comment. ───┐
                                                       │
                                                       │
                                                       ↓

                                                       */

    hour = 12       /*high noon                   */
midnight = 00       /*first hour of the day       */
   suits = 1234     /*card suits:   ♥  ♦  ♣  ♠    */

hutchHdr = '/*'
hutchEnd = "*/"

    /* the previous two "hutch" assignments aren't
       the start  nor  the end of a REXX comment. */

  x=1000000 **   /*¡big power!*/   1000

/*not a real good place for a comment (above),
  but essentially, a REXX comment can be
  anywhere whitespace is allowed.            */
