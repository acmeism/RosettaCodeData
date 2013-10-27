/*REXX program to show how to display embedded documention in REXX code.*/
parse arg doc
doc=space(doc)
if doc=='?'  then call help            /*show doc if arg is a single  ? */
/*════════════════════════regular═══════════════════════════════════════*/
/*════════════════════════════════mainline══════════════════════════════*/
/*═════════════════════════════════════════code═════════════════════════*/
/*══════════════════════════════════════════════here.═══════════════════*/
exit

/*──────────────────────────────────HELP subroutine─────────────────────*/
help: help=0;       do j=1  for sourceline()
                    _=sourceline(j)
                    if _=='<help>' then do; help=1; iterate;  end
                    if _=='</help>' then exit
                    if help then say _
                    end   /*j*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────start of the in─line documentation.
<help>
To use the  YYYY   program, enter:


      YYYY   numberOfItems
      YYYY                               (with no args for the default)
      YYYY   ?                           (to see this documentation)


─── where:

numberOfItems                 is the number of items to be processed.

If no  "numberOfItems"  are entered, the default of 100 is used.
</help>
────────────────────────────────────end of the in─line documentation.   */
