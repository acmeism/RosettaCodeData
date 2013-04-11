/*REXX program sorts an array using the cocktail-sort method,  a.k.a.:  */
                                       /*    bidirectional bubble sort, */
                                       /*    cocktail shaker sort,      */
                                       /*    a selection sort variation,*/
                                       /*    ripple sort,               */
                                       /*    shuffle sort,              */
                                       /*    shuttle sort,              */
                                       /*    happy hour sort,           */
                                       /*    a bubble sort variation.   */

call gen@                              /*generate some array elements.  */
call show@ 'before sort'               /*show  unsorted  array elements.*/
call cocktailSort highItem             /*invoke cocktail sort subroutine*/
call show@ ' after sort'               /*show    sorted  array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────COCKTAILSORT subroutine─────────────*/
cocktailSort:   procedure expose @.;   parse arg N       /*N=# of items.*/

        do until done;    done=1

            do j=1   for N-1;          jp=j+1
            if @.j>@.jp then do;  done=0;  _=@.j;  @.j=@.jp;  @.jp=_;  end
            end   /*j*/

        if done then leave             /*No swaps done?  Then we're done*/

            do k=N-1 for N-1  by -1;   kp=k+1
            if @.k>@.kp then do;  done=0;  _=@.k;  @.k=@.kp;  @.kp=_;  end
            end   /*k*/

        end       /*until*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:  @.=''                           /*assign default value for stem. */
@.1 ='---the 22 card tarot deck (larger deck has 56 additional cards in 4 suits)---'
@.2 ='==========symbol====================pip======================================'
@.3 ='the juggler                  ◄───     I'
@.4 ='the high priestess  [Popess] ◄───    II'
@.5 ='the empress                  ◄───   III'
@.6 ='the emperor                  ◄───    IV'
@.7 ='the hierophant  [Pope]       ◄───     V'
@.8 ='the lovers                   ◄───    VI'
@.9 ='the chariot                  ◄───   VII'
@.10='justice                      ◄───  VIII'
@.11='the hermit                   ◄───    IX'
@.12='fortune  [the wheel of]      ◄───     X'
@.13='strength                     ◄───    XI'
@.14='the hanging man              ◄───   XII'
@.15='death  [often unlabeled]     ◄───  XIII'
@.16='temperance                   ◄───   XIV'
@.17='the devil                    ◄───    XV'
@.18='lightning  [the tower]       ◄───   XVI'
@.18='the stars                    ◄───  XVII'
@.20='the moon                     ◄─── XVIII'
@.21='the sun                      ◄───   XIX'
@.22='judgment                     ◄───    XX'
@.23='the world                    ◄───   XXI'
@.24='the fool  [often unnumbered] ◄───  XXII'

  do i=1 while @.i\=='';   end         /*find how many entries in array.*/

highItem=i-1                           /*adjust for DO loop advancement.*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*the maximum width of any line. */

                        do j=1 for highItem
                        say 'element' right(j,widthH) arg(1)":" @.j
                        end
say copies('─',79)                     /*show a separator line or fence.*/
return
