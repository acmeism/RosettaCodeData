/*REXX program compares a list of  (character) strings for:   equality,  all ascending. */
@.1= 'ayu dab dog gar panda tui yak'             /*seven strings: they're all ascending.*/
@.2= 'oy oy oy oy oy oy oy oy oy oy'             /*  ten strings:         all equal.    */
@.3= 'somehow   somewhere  sometime'             /*three strings:   ¬equal,  ¬ascending.*/
@.4= 'Hoosiers'                                  /*only a single string is defined.     */
@.5=                                             /*Null.   That is,  no strings here.   */
         do j=1  for 5;    say;   say            /* [↓]  traipse through all the lists. */
         say center(' '@.j, 50, "═")             /*display a centered title/header.     */
         if ifEqual( @.j)  then  say 'strings are all equal.'
         if ifAscend(@.j)  then  say 'strings are ascending.'
         end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ifEqual:  procedure; parse arg strings           /*set  STRINGS  to a string in the list*/
            do k=2  to words(strings)            /*scan the strings in the list.        */
            if word(strings,k)\==word(strings,k-1)  then return 0        /*string=prev? */
            end   /*k*/                          /* [↑]     0=false,   [↓] 1=true.      */
          return 1                               /*indicate that all strings are equal. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ifAscend: procedure; parse arg strings           /*set  STRINGS  to a string in the list*/
            do k=2  to words(strings)            /*scan the strings in the list.        */
            if word(strings,k)<<=word(strings,k-1)  then return 0        /*string>prev? */
            end   /*k*/                          /*  [↑]    0=false,     [↓]    1=true. */
          return 1                               /*indicate that strings are ascending. */
