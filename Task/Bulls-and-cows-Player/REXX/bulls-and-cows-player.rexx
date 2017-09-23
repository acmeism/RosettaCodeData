/*REXX program plays the    Bulls & Cows   game with  CBLFs (Carbon Based Life Forms).  */
call gen@                                        /*generate all the possibilities.      */
call #                                           /*get the first guess for the game.    */

  do tries=1  until #()<2 | bull==4;   say
  call prompter
               do ?=L  to H                      /*traipse through the whole list.      */
               if @.?==.  then iterate           /*was this choice already eliminated ? */
               call bull#  ?,g                   /*obtain the  bulls and cows  count.   */
               if bull\==bulls | cow\==cows  then @.?=.             /*eliminate choice. */
               end   /*?*/
  call #
  end   /*tries*/

if #==0  then do;  call serr "At least one of your responses was invalid.";  exit;     end
say;     say "           ╔═════════════════════════════════════════════════╗"
         say "           ║                                                 ║"
         say "           ║   Your secret Bulls and Cows number is: " g  "  ║"
         say "           ║                                                 ║"
         say "           ╚═════════════════════════════════════════════════╝";         say
say tries  'tries.'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#:     #=0;   do k=L to H; if @.k==.  then iterate;  #=#+1; g=k; end;        return #
gen@:  @.=.;  L=1234;  H=9876;  do j=L  to H; if genOK()  then @.j=j;  end;  return
genOK: if pos(0, j)\==0  then return 0;                                      return \rep()
rep:   do k=1  for 3; if pos(substr(j,k,1),j,k+1)\==0  then return 1;  end;  return 0
serr:  say;   say pad   '***error***   '     !    arg(1);                    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bull#: parse arg n,q;     L=length(n);    bulls=0;    cows=0     /*initialize some vars.*/
              do j=1  for L;    if substr(n,j,1) \== substr(q,j,1)  then iterate
              bulls=bulls+1                            /*bump the    bull    counter.   */
              q=overlay(.,q,j)                         /*disallow this for a cow  count.*/
              end   /*j*/                              /* [↑]  bull count═══════════════*/

              do k=1  for L;    _=substr(n,k,1);    if pos(_, q)==0  then iterate
              cows=cows + 1                            /*bump the    cow     counter.   */
              q=translate(q, , _)                      /*this allows for multiple digits*/
              end   /*k*/                              /* [↑]  cow  count═══════════════*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
prompter:                   pad= '─────'               /*define PAD characters for msgs.*/
          do forever;       say
          say pad "How many bulls and cows were guessed with "    g   '?    [─── or QUIT]'
          pull x 1 bull cow _ .                        /*PULL capitalizes the arguments.*/
          if abbrev('QUIT', x, 1)      then exit       /*the user wants to quit playing.*/
            select
            when bull==''              then != "no numbers were entered."
            when cow ==''              then != "not enough numbers were entered."
            when _\==''                then != "too many numbers entered: "            x
            when \datatype(bull, 'W')  then != "1st number (bulls) not an integer: "  bull
            when \datatype(cow , 'W')  then != "2nd number (cows) not an integer: "   cow
            when bull <0 | bull >4     then != "1st number (bulls) not 0 ──► 4: "     bull
            when cow  <0 | cow  >4     then != "2nd number (cows) not 0 ──► 4: "      cow
            when bull + cow > 4        then != "sum of bulls and cows can't be > 4: "  x
            otherwise                       !=
            end   /*select*/
          if !\==''  then do; call serr; iterate; end  /*prompt the user and try again. */
          bull=bull/1;        cow=cow/1;       return  /*normalize bulls & cows numbers.*/
          end   /*forever*/
