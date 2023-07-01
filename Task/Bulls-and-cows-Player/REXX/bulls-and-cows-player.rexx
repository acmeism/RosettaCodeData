/*REXX program plays the    Bulls & Cows   game with  CBLFs (Carbon Based Life Forms).  */
parse arg ? .;   if datatype(?,'W')  then call random ,,? /*Random seed? Make repeatable*/
L=1234;  H=9876;    call gen@                             /*generate all possibilities. */
       do forever;  g=random(L,H); if @.g\==.  then leave /*obtain a random 1st guess.  */
       end   /*forever*/                                  /* [↑]  obtain rand 1st guess.*/
$$1= '───── How many bulls and cows were guessed with '; $$2=" ?            [─── or QUIT]"
       do until #()<2 | bull==4;   say;   call ask        /*examine @ list;  get answer.*/
           do ?=L  to H;     if @.?==.  then iterate      /*is this already eliminated ?*/
           call bull#  ?,g                                /*obtain bulls and cows count.*/
           if bull\==bulls | cow\==cows  then @.?=.       /*eliminate this possibility. */
           end   /*?*/
       end   /*until*/

if #==0  then do;  call serr  "At least one of your responses was invalid.";  exit;    end
say;   say "           ╔═════════════════════════════════════════════════╗"
       say "           ║                                                 ║"
       say "           ║   Your secret Bulls and Cows number is: " g  "  ║"
       say "           ║                                                 ║"
       say "           ╚═════════════════════════════════════════════════╝";           say
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
#:     #=0;    do k=L  to H;  if @.k==.  then iterate;  #=#+1;   g=k;  end;       return #
gen@:  @.=.;   do j=L  to H;  if \rep() & pos(0, j)==0  then @.j=j;    end;       return
rep:   do k=1  for 3;  if pos(substr(j, k, 1), j, k+1)\==0  then return 1;   end; return 0
serr:  say;    say  '───── ***error***   '      !     arg(1);                     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bull#: parse arg n,q;     w=length(n);    bulls=0      /*W: # digits in N;  bull cntr=0 */
              do j=1  for w;    if substr(n, j, 1) \== substr(q, j, 1)  then iterate
              bulls=bulls+1;    q=overlay(., q, j)     /*bump counter;  disallow for cow*/
              end   /*j*/                              /* [↑]  bull count═══════════════*/
       cows=0                                          /*set the number of cows to zero.*/
              do k=1  for w;    _=substr(n, k, 1);   if pos(_, q)==0  then iterate
              cows=cows + 1;    q=translate(q, , _)    /*bump counter;  allow multiple #*/
              end   /*k*/                              /* [↑]  cow  count═══════════════*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
ask:   do forever; say $$1 g $$2;  pull x 1 bull cow . /*display prompt;  obtain answer.*/
          select                                       /* [↑]  PULL capitalizes the args*/
          when abbrev('QUIT', x, 1)  then exit         /*the user wants to quit playing.*/
          when bull == ''            then != "no numbers were entered."
          when cow  == ''            then != "not enough numbers were entered."
          when words(x) > 2          then != "too many numbers entered: "              x
          when \datatype(bull, 'W')  then != "1st number (bulls) not an integer: "    bull
          when \datatype(cow , 'W')  then != "2nd number (cows) not an integer: "     cow
          when bull <0 | bull >4     then != "1st number (bulls) not 0 ──► 4: "       bull
          when cow  <0 | cow  >4     then != "2nd number (cows) not 0 ──► 4: "        cow
          when bull + cow > 4        then != "sum of bulls and cows can't be > 4: "    x
          otherwise                       !=
          end   /*select*/
       if !\==''  then do;  call serr;  iterate;  end  /*prompt the user and try again. */
       bull=bull/1;         cow=cow/1;  return         /*normalize bulls & cows numbers.*/
       end     /*forever*/
