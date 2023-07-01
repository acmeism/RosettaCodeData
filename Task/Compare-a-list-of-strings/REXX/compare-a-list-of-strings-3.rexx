/*REXX program compares a list of strings for:  equality, all ascending.                */
@.1= 'ayu dab dog gar panda tui yak'             /*seven strings: they're all ascending.*/
@.2= 'oy oy oy oy oy oy oy oy oy oy'             /*  ten strings:         all equal.    */
@.3= 'somehow   somewhere  sometime'             /*three strings:   ¬equal,  ¬ascending.*/
@.4= 'Hoosiers'                                  /*only a single string is defined.     */
@.5=                                             /*Null.   That is,  no strings here.   */
#= 5;         do j=1  for #;    say;   say       /* [↓]  traipse through all the lists. */
              say center(' '@.j, 50, "═")        /*display a centered title/header.     */
              if cStr(@.j, 'Equal'    )  then  say  "  The strings are all equal."
              if cStr(@.j, 'Ascending')  then  say  "  The strings are ascending."
              end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cStr: procedure; parse arg x;  arg , how 2       /*set X to list; get 1st char of arg #2*/
              do k=2  to words(x)                /*scan the strings in the list.        */
              if how=='E'  then if word(x,k) \== word(x,k-1)  then return 0   /*¬=prev.?*/
              if how=='A'  then if word(x,k) <<= word(x,k-1)  then return 0   /*≤ prev.?*/
              end   /*k*/                        /* [↓]   1=true.        [↑]   0=false. */
      return 1                                   /*indicate strings have true comparison*/
