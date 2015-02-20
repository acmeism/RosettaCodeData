/*REXX pgm plays Bulls & Cows game with CBLFs (Carbon Based Life Forms).*/
call gen@                              /*generate all the possibilities.*/
call #                                 /*get the first guess for game.  */

  do tries=1  until #()<2 | bull==4;   say
  call prompter
               do ?=L to H             /*traipse through the whole list.*/
               if @.?==.  then iterate /*was this already eliminated ?  */
               call bull#  ?,g         /*obtain the bulls & cows count. */
               if bull\==bulls | cow\==cows  then @.?=.   /*eliminate it*/
               end   /*?*/
  call #
  end   /*tries*/

if #==0  then do; call sayErr "At least one of your responses was invalid."; exit; end
pad=left('',9)
say;  say pad " ┌─────────────────────────────────────────────────┐"
      say pad " │                                                 │"
      say pad " │   Your secret Bulls and Cows number is: " g  "  │"
      say pad " │                                                 │"
      say pad " └─────────────────────────────────────────────────┘";  say
say tries 'tries.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
#: #=0;   do k=L to H;  if @.k==.  then iterate;   #=#+1;    g=k; end;  return #
gen@: @.=.; L=1234; H=9876; do j=L to H;  if genOK()  then @.j=j; end;  return
genOK: if pos(0,j)\==0  then return 0;    return \rep()
rep: do k=1 for 3; if pos(substr(j,k,1),j,k+1)\==0 then return 1; end; return 0
sayErr: say;   say pad   '***error!***   '    em  arg(1);         return
/*──────────────────────────────────BULL# subroutine────────────────────*/
bull#: parse arg n,q;  L=length(n);  bulls=0;  cows=0  /*init. some vars*/

       do j=1  for L;      if substr(n,j,1)\==substr(q,j,1)  then iterate
       bulls=bulls+1                   /*bump the    bull    count.     */
       q=overlay(.,q,j)                /*disallow this for a cow count. */
       end   /*j*/                     /* [↑]  bull count───────────────*/

       do k=1  for L;      _=substr(n,k,1);   if pos(_,q)==0  then iterate
       cows=cows+1                     /*bump the    cow    count.      */
       q=translate(q,,_)               /*this allows for multiple digits*/
       end   /*k*/                     /* [↑]  cow  count───────────────*/
return
/*──────────────────────────────────PROMPTER subroutine─────────────────*/
prompter:           pad='─────'        /*define PAD chars for messages. */
  do forever;       say
  say pad "How many bulls and cows were guessed with "   g   '?    [─── or QUIT]'
  pull x 1 bull cow _ .                     /*PULL capitalizes the args.*/
  if abbrev('QUIT',x,1)       then exit     /*user wants to quit playing*/
    select
    when bull==''             then em="no numbers were entered."
    when cow ==''             then em="not enough numbers were entered."
    when _\==''               then em="too many numbers entered: " x
    when \datatype(bull,'W')  then em="1st number (bulls) not an integer: " bull
    when \datatype(cow ,'W')  then em="2nd number (cows) not an integer: "  cow
    when bull <0 | bull >4    then em="1st number (bulls) not 0──►4: "      bull
    when cow  <0 | cow  >4    then em="2nd number (cows) not 0──►4: "       cow
    when bull + cow > 4       then em="sum of bulls and cows can't be > 4: " x
    otherwise                      em=
    end   /*select*/
  if em\==''  then do; call sayErr; iterate;  end   /*prompt user again.*/
  bull=bull/1;  cow=cow/1              /*normalize the two answers.     */
  return                               /*we've got two kosher numbers.  */
  end   /*forever*/
