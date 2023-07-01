/*REXX pgm computes/displays the Jacobi symbol, the # of rows & columns can be specified*/
parse arg rows cols .                            /*obtain optional arguments from the CL*/
if rows='' | rows==","  then rows= 17            /*Not specified?  Then use the default.*/
if cols='' | cols==","  then cols= 16            /* "      "         "   "   "      "   */
call hdrs                                        /*display the (two) headers to the term*/
      do r=1  by 2  to rows;     _= right(r, 3)  /*build odd (numbered) rows of a table.*/
                         do c=0  to cols         /* [↓]  build a column for a table row.*/
                         _= _ ! right(jacobi(c, r), 2);   != '│'  /*reset grid end char.*/
                         end   /*c*/
      say _ '║';  != '║'                         /*display a table row; reset grid glyph*/
      end   /*r*/
say translate(@.2, '╩╧╝', "╬╤╗")                 /*display the bottom of the grid border*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hdrs: @.1= 'n/a ║';      do c=0  to cols;    @.1= @.1 || right(c, 3)"  ";   end
      L= length(@.1);                        @.1= left(@.1,   L - 1)    ;          say @.1
      @.2= '════╬';      do c=0  to cols;    @.2= @.2 || "════╤"        ;   end
      L= length(@.2);                        @.2= left(@.2,   L - 1)"╗" ;          say @.2
      != '║'        ;    return                  /*define an external grid border glyph.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
jacobi: procedure; parse arg a,n;  er= '***error***';        $ = 1      /*define result.*/
        if n//2==0  then do;   say er    n   " must be a positive odd integer.";   exit 13
                         end
        a= a // n                                      /*obtain  A  modulus  N          */
          do while a\==0                               /*perform while  A  isn't zero.  */
                         do while a//2==0;  a= a % 2   /*divide  A  (as a integer) by 2 */
                         if n//8==3 | n//8==5  then $= -$               /*use  N mod  8 */
                         end   /*while a//2==0*/
          parse value  a  n     with     n  a          /*swap values of variables:  A N */
          if a//4==3 & n//4==3  then $= -$             /* A mod 4, N mod 4.   Both ≡ 3 ?*/
          a= a // n                                    /*obtain  A  modulus  N          */
          end   /*while a\==0*/
        if n==1  then return $
                      return 0
