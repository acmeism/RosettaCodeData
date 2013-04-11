/*REXX program  parses  an   S-expression   and  displays the results.  */
input= '((data "quoted data" 123 4.5) (data (!@# (4.5) "(more" "data)")))'
say 'input:'                           /*indicate what is being shown.  */
say  input                             /*echo the input to the screen.  */
say copies('═',length(input))          /*display a header fence.        */
$.=                                    /*stem array to hold the tokens. */
groupO.1 = '{' ;    groupC.1 = '}'     /*grouping symbols (Open & Close)*/
groupO.2 = '[' ;    groupC.2 = ']'     /*    "       "       "  "   "   */
groupO.3 = '(' ;    groupC.3 = ')'     /*    "       "       "  "   "   */
groupSym = 3                           /*the number of grouping symbols.*/
#        = 0                           /*the number of tokens.          */
tabs     = 10                          /*used for indenting the levels. */
q.1      = "'"                         /*literal string delimiter, 1st. */
q.2      = '"'                         /*    "      "       "      2nd. */
numLits  = 2                           /*number of kinds of literals.   */
seps     = ',;'                        /*characters used for separation.*/
atoms    = ' 'seps                     /*characters used to sep atoms.  */
level    = 0                           /*current level being processed. */
quoted   = 0                           /*quotation level (when nested). */
groupu   =                             /*used to go ↑ an expresion level*/
groupd   =                             /*  "   "  " ↓  "     "       "  */
            do n=1  for groupSym       /*handle for # grouping symbols. */
            atoms  = atoms  || groupO.n || groupC.n
            groupu = groupu || groupO.n
            groupd = groupd || groupC.n
            end   /*n*/
literals=
            do k=1  for numLits
            literals = literals || q.k
            end   /*k*/
!=
/*═════════════════════════════════════start of the text parsing.═══════*/
  do j=1  to length(input);   _ = substr(input,j,1)
  if quoted then do
                 !=! || _
                 if _==literalStart  then quoted=0
                 iterate
                 end

  if pos(_,literals)\==0 then do
                              literalStart = _
                              ! = ! || _
                              quoted = 1
                              iterate
                              end

  if pos(_,atoms)==0  then do;  !=! || _ ;  iterate;  end
                      else do;  call add!;  ! = _  ;  end

  if pos(_,literals)==0 then do
                             if pos(_,groupu)\==0  then level=level+1
                             call add!
                             if pos(_,groupd)\==0  then level=level-1
                             if level<0     then say 'oops, mismatched' _
                             iterate
                             end
  end   /*j*/

call add!                              /*handle any residual tokens.    */
if level\==0  then say 'oops, mismatched grouping symbol'
if quoted     then say 'oops, no end of quoted literal' literalStart
/*═════════════════════════════════════end of text parsing.═════════════*/

              do j=1  for #
              say $.j
              end   /*j*/
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ADD! subroutine─────────────────────*/
add!: if !\=''  then do
                     #=#+1
                     $.#=left('',max(0,tabs*(level-1)))!
                     end
      !=
      return
