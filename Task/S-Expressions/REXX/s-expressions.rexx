/*REXX program  parses  an   S-expression   and  displays the results.                  */
input= '((data "quoted data" 123 4.5) (data (!@# (4.5) "(more" "data)")))'
say 'input:';       say input                    /*display the input data string to term*/
say copies('═', length(input))                   /*also,  display a header fence.       */
groupO.=                                         /*default value for grouping symbols.  */
groupO.1 = '{' ;    groupC.1 = "}"               /*grouping symbols  (Open & Close).    */
groupO.2 = '[' ;    groupC.2 = "]"               /*    "       "        "  "   "        */
groupO.3 = '(' ;    groupC.3 = ")"               /*    "       "        "  "   "        */
#        = 0                                     /*the number of tokens found (so far). */
tabs     = 10                                    /*used for the indenting of the levels.*/
q.1      = "'"                                   /*literal string delimiter,  first.    */
q.2      = '"'                                   /*    "      "       "       second.   */
numLits  = 2                                     /*the number of kinds of literals.     */
seps     = ',;'                                  /*characters used for separation.      */
atoms    = ' 'seps                               /*characters used to separate atoms.   */
level    = 0                                     /*the current level being processed.   */
quoted   = 0                                     /*quotation level  (when nested).      */
groupu   =                                       /*used to go  ↑  an expression level.  */
groupd   =                                       /*  "   "  "  ↓   "     "       "      */
$.=                                              /*the stem array to hold the tokens.   */
           do n=1  while groupO.n\==''           /*handle the number of grouping symbols*/
           atoms =atoms  || groupO.n || groupC.n
           groupu=groupu || groupO.n
           groupd=groupd || groupC.n
           end   /*n*/
literals=
           do k=1  for numLits
           literals=literals || q.k
           end   /*k*/
!=
     /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ text parsing ▒▒▒▒▒▒▒▒*/
  do j=1  to length(input);                _=substr(input,j,1)                       /*▒*/
                                                                                     /*▒*/
  if quoted  then do;  !=! || _                                                      /*▒*/
                       if _==literalStart  then quoted=0                             /*▒*/
                       iterate                                                       /*▒*/
                  end                                                                /*▒*/
                                                                                     /*▒*/
  if pos(_,literals)\==0 then do;  literalStart=_                                    /*▒*/
                                   !=! || _                                          /*▒*/
                                   quoted=1                                          /*▒*/
                                   iterate                                           /*▒*/
                              end                                                    /*▒*/
                                                                                     /*▒*/
  if pos(_,atoms)==0  then do;  !=! || _ ;  iterate;  end                            /*▒*/
                      else do;  call add!;  !=_;      end                            /*▒*/
                                                                                     /*▒*/
  if pos(_,literals)==0 then do;   if pos(_,groupu)\==0  then level=level+1          /*▒*/
                                   call add!                                         /*▒*/
                                   if pos(_,groupd)\==0  then level=level-1          /*▒*/
                                   if level<0   then say 'oops, mismatched' _        /*▒*/
                             end                                                     /*▒*/
  end   /*j*/                                                                        /*▒*/
                                                                                     /*▒*/
call add!                                        /*handle any residual tokens.*/     /*▒*/
if level\==0  then say  'oops, mismatched grouping symbol'                           /*▒*/
if quoted     then say  'oops, no end of quoted literal'      literalStart           /*▒*/
     /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/

      do m=1  for #;  say $.m;  end  /*m*/       /*display the tokens to the terminal.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add!: if !\=''  then do;  #=#+1;  $.#=left('', max(0, tabs*(level-1)))!;  end;          !=
      return
