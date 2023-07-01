/*REXX program displays a  NxN  multiplication table  (in a boxed grid) to the terminal.*/
parse arg sz .                                   /*obtain optional argument from the CL.*/
if sz=='' | sz==","  then sz= 12                 /*Not specified?  Then use the default.*/
w= max(3, length(sz**2) );    __= copies('─', w) /*calculate the width of the table cell*/
                             ___= __'──'         /*literals used in the subroutines.    */
        do r=1  for sz                           /*calculate & format a row of the table*/
        if r==1  then call top left('│(x)', w+1) /*show title of multiplication table.  */
        $= '│'center(r"x", w)"│"                 /*index for a multiplication table row.*/
               do c=1  for sz;     prod=         /*build a row of multiplication table. */
               if r<=c  then prod= r * c         /*only display when the  row ≤ column. */
               $= $  ||  right(prod,  w+1) '|'   /*append product to a cell in the row. */
               end   /*k*/
        say $                                    /*show a row of multiplication table.  */
        if r\==sz  then call sep                 /*show a separator except for last row.*/
        end          /*j*/
call bot                                         /*show the bottom line of the table.   */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hdr: $= ?'│';   do i=1  for sz; $=$ || right(i"x|", w+3);  end;  say $;   call sep; return
dap: $= left($, length($) - 1)arg(1);                                               return
top: $= '┌'__"┬"copies(___'┬', sz);  call dap "┐";  ?= arg(1);   say $;   call hdr; return
sep: $= '├'__"┼"copies(___'┼', sz);  call dap "┤";               say $;             return
bot: $= '└'__"┴"copies(___'┴', sz);  call dap "┘";               say $;             return
