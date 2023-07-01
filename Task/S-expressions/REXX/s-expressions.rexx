/*REXX program  parses  an   S-expression   and  displays the results to the terminal.  */
input= '((data "quoted data" 123 4.5) (data (!@# (4.5) "(more" "data)")))'
say center('input', length(input), "═")          /*display the header title to terminal.*/
say         input                                /*   "     "  input data    "    "     */
say copies('═',     length(input) )              /*   "     "  header sep    "    "     */
grpO.=;      grpO.1 = '{'   ;    grpC.1 = "}"    /*pair of grouping symbol: braces      */
             grpO.2 = '['   ;    grpC.2 = "]"    /*  "   "    "       "     brackets    */
             grpO.3 = '('   ;    grpC.3 = ")"    /*  "   "    "       "     parentheses */
             grpO.4 = '«'   ;    grpC.4 = "»"    /*  "   "    "       "     guillemets  */
q.=;            q.1 = "'"   ;       q.2 = '"'    /*1st and 2nd literal string delimiter.*/
#        = 0                                     /*the number of tokens found (so far). */
tabs     = 10                                    /*used for the indenting of the levels.*/
seps     = ',;'                                  /*characters used for separation.      */
atoms    = ' 'seps                               /*     "       "  to  separate atoms.  */
level    = 0                                     /*the current level being processed.   */
quoted   = 0                                     /*quotation level  (for nested quotes).*/
grpU     =                                       /*used to go   up  an expression level.*/
grpD     =                                       /*  "   "  "  down  "     "       "    */
@.=;        do n=1  while grpO.n\==''
            atoms = atoms || grpO.n || grpC.n    /*add Open and Closed groups to  ATOMS.*/
            grpU  = grpU  || grpO.n              /*add Open            groups to  GRPU, */
            grpD  = grpD  || grpC.n              /*add          Closed groups to  GRPD, */
            end   /*n*/                          /* [↑]  handle a bunch of grouping syms*/
literals=
            do k=1  while q.k\=='';  literals= literals || q.k  /*add literal delimiters*/
            end   /*k*/
!=;                                      literalStart=
      do j=1  to length(input);          $= substr(input, j, 1)                              /* ◄■■■■■text parsing*/
                                                                                             /* ◄■■■■■text parsing*/
      if quoted                then do;  !=! || $;    if $==literalStart  then quoted= 0     /* ◄■■■■■text parsing*/
                                         iterate                                             /* ◄■■■■■text parsing*/
                                    end          /* [↑]  handle running  quoted string. */   /* ◄■■■■■text parsing*/
                                                                                             /* ◄■■■■■text parsing*/
      if pos($, literals)\==0  then do;  literalStart= $;      != ! || $;        quoted= 1   /* ◄■■■■■text parsing*/
                                         iterate                                             /* ◄■■■■■text parsing*/
                                    end          /* [↑]  handle start of quoted strring.*/   /* ◄■■■■■text parsing*/
                                                                                             /* ◄■■■■■text parsing*/
      if pos($, atoms)==0      then do;  != ! || $;   iterate;   end    /*is    an atom?*/   /* ◄■■■■■text parsing*/
                               else do;  call add!;   != $;      end    /*isn't  "   " ?*/   /* ◄■■■■■text parsing*/
                                                                                             /* ◄■■■■■text parsing*/
      if pos($, literals)==0   then do;  if pos($, grpU)\==0  then level= level + 1          /* ◄■■■■■text parsing*/
                                         call add!                                           /* ◄■■■■■text parsing*/
                                         if pos($, grpD)\==0  then level= level - 1          /* ◄■■■■■text parsing*/
                                         if level<0  then say  'error, mismatched'   $       /* ◄■■■■■text parsing*/
                                    end                                                      /* ◄■■■■■text parsing*/
      end   /*j*/                                                                            /* ◄■■■■■text parsing*/
                                                                                             /* ◄■■■■■text parsing*/
call add!                                        /*process any residual tokens.         */   /* ◄■■■■■text parsing*/
if level\==0  then say  'error, mismatched grouping symbol'                                  /* ◄■■■■■text parsing*/
if quoted     then say  'error, no end of quoted literal'      literalStart                  /* ◄■■■■■text parsing*/

      do m=1  for #;   say @.m                   /*display the tokens  ───►  terminal.  */
      end   /*m*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add!: if !=''  then return;   #=#+1;  @.#=left("", max(0, tabs*(level-1)))!;  !=;   return
