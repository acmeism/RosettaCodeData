/*REXX program sorts an array using the cocktail─sort method,  A.K.A.:  happy hour sort,*/
                                                 /*   bidirectional bubble sort,        */
                                                 /*   cocktail shaker sort, ripple sort,*/
                                                 /*   a selection sort variation,       */
                                                 /*   shuffle sort,  shuttle sort,   or */
                                                 /*   a bubble sort variation.          */
call genItems                                    /*generate some array elements.        */
call showItems 'before sort'                     /*show  unsorted  array elements.      */
say copies('█', 101)                             /*show a separator line  (a fence).    */
call cocktailSort                                /*invoke the cocktail sort subroutine. */
call showItems ' after sort'                     /*show    sorted  array elements.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cocktailSort: procedure expose items.
    nn = items.0 - 1                                    /*items.0:  is number of items. */
    do until done
        done = 1
        do j = 1 for nn
            jp = j + 1        /* Rexx doesn't allow "items.(j+1)", so use this instead. */
            if items.j > items.jp then do
                done = 0
                temp = items.j
                items.j = items.jp
                items.jp = temp
            end
        end /*j*/
        if done then leave                                    /*No swaps done?  Finished*/
        do k = nn for nn by -1
            kp = k + 1        /* Rexx doesn't allow "items.(k+1)", so use this instead. */
            if items.k > items.kp  then do
                done = 0
                temp = items.k
                items.k = items.kp
                items.kp = temp
            end
        end /*k*/
    end /*until*/
	
    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genitems: procedure expose items.
    items.=                                      /*assign a default value for the stem. */
    items.1 ='---the 22 card tarot deck (larger deck has 56 additional cards in 4 suits)---'
    items.2 ='==========symbol====================pip======================================'
    items.3 ='the juggler                  ◄───     I'
    items.4 ='the high priestess  [Popess] ◄───    II'
    items.5 ='the empress                  ◄───   III'
    items.6 ='the emperor                  ◄───    IV'
    items.7 ='the hierophant  [Pope]       ◄───     V'
    items.8 ='the lovers                   ◄───    VI'
    items.9 ='the chariot                  ◄───   VII'
    items.10='justice                      ◄───  VIII'
    items.11='the hermit                   ◄───    IX'
    items.12='fortune  [the wheel of]      ◄───     X'
    items.13='strength                     ◄───    XI'
    items.14='the hanging man              ◄───   XII'
    items.15='death  [often unlabeled]     ◄───  XIII'
    items.16='temperance                   ◄───   XIV'
    items.17='the devil                    ◄───    XV'
    items.18='lightning  [the tower]       ◄───   XVI'
    items.19='the stars                    ◄───  XVII'
    items.20='the moon                     ◄─── XVIII'
    items.21='the sun                      ◄───   XIX'
    items.22='judgment                     ◄───    XX'
    items.23='the world                    ◄───   XXI'
    items.24='the fool  [often unnumbered] ◄───  XXII'
    items.0 =24                                      /* number of entries in the array. */

    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showitems: procedure expose items.
    parse arg phase
    width = length(items.0)
    do j=1 to items.0                       /* items.0 is the number of items in items. */
        say 'element' right(j, width) phase || ":" items.j
    end /*j*/           /*     ↑                                   */
                        /*     └─────max width of any line number. */
    return
