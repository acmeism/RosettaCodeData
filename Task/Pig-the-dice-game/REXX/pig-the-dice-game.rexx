/*REXX program plays pig the dice game (any # of CBLFs and/or silicons).*/
signal on syntax; signal on novalue    /*handle REXX program errors.    */
sw=linesize()-1                        /*get the width of the terminal. */
parse arg hp cp win die _ . '(' names ")"   /*obtain optional arguments.*/
                                       /*names with blanks should use _ */
if _\==''  then  call  err  'too many arguments were specified: ' _
@nhp  = 'number of human players'   ;  hp =scrutinize( hp,@nhp , 0, 0, 0)
@ncp  = 'number of computer players';  cp =scrutinize( cp,@ncp , 0, 0, 2)
@sn2w = 'score needed to win'       ;  win=scrutinize(win,@sn2w, 1,1e6,60)
@nsid = 'number of sides in die'    ;  die=scrutinize(die,@nsid, 2,999, 6)
if hp==0  &  cp==0   then cp=2         /*if both counts are zero, 2 HALs*/
if hp==1  &  cp==0   then cp=1         /*if one human, then use   1 HAL.*/
name.=                                 /*nullify all names (to a blank).*/
L=0                                    /*maximum length of a player name*/
       do i=1  for hp+cp               /*get the player's names, maybe. */
       if i>hp  then @='HAL_'i"_the_computer"    /*use this for default.*/
                else @='player_'i                /* "    "   "     "    */
       name.i = translate( word( strip( word(names,i)) @, 1),,'_')
       L=max(L, length(name.i))        /*use L for nice name formatting.*/
       end   /*i*/                     /*underscores are changed─►blanks*/

hpn=hp;  if hpn==0   then hpn='no'     /*use normal English for display.*/
cpn=cp;  if cpn==0   then cpn="no"     /* "     "      "     "     "    */
say 'Pig (the dice game) is being played with:'   /*introduction to pig.*/
         if cpn\==0  then  say  right(cpn,9)  'computer player's(cp)
         if hpn\==0  then  say  right(hpn,9)  'human player's(hp)
say 'and the' @sn2w "is: " win '   (or greater).'
!.=;   dieNames='ace deuce trey square nickle boxcar'  /*die face names.*/
                                       /*note: snake eyes is for 2 aces.*/
!w=0;          do i=1  for die;        !.i=' ['word(dieNames,i)"]"
               !w=max(!w, length(!.i)) /*!w ──► maximum length die name.*/
               end   /*i*/
s.=0                                   /*set all player's scores to zero*/
!w=!w+length(die)+3                    /*pad the die number and die name*/
@=copies('─',9)                        /*an eyecatcher (for prompting). */
@jra='just rolled a ';  @ati='and the inning'   /*nice literals to have.*/
/*──────────────────────────────────────────────────let's play some pig.*/
   do game=1;  in.=0                   /*set each inning's score to zero*/
   say;      say copies('█',sw)        /*display a fence for da eyeballs*/

      do k=1  for hp+cp                /*display the scores (as a recap)*/
      say 'The score for ' left(name.k,L) " is " right(s.k,length(win))'.'
      end  /*k*/

   say copies('█',sw)                  /*display a fence for da eyeballs*/

     do j=1  for hp+cp                 /*let each player roll their dice*/
     say;  say copies('─',sw);         /*display a fence for da eyeballs*/
     it=name.j
     say it',  your total score (so far) in this pig game is: '   s.j"."

       do  until  stopped              /*keep prompting/rolling 'til not*/
       r=random(1,die)                 /*get a random die face (number).*/
       !=left(space(r !.r','), !w)     /*for color, use a die-face name.*/
       in.j=in.j+r                     /*add die-face number to inning. */
       if r==1  then  do;  say it @jra ! || @ati "is a bust."; leave;  end
                           say it @jra ! || @ati "total is: "    in.j
       stopped=what2do(j)              /*determine|ask  to stop rolling.*/
       if j>hp & stopped then say ' and' name.j "elected to stop rolling."
       end   /*until stopped*/

     if r\==1     then s.j=s.j+in.j    /*if not a bust, then add inning.*/
     if s.j>=win  then leave game      /*we have a winner, so game ends.*/
     end     /*j*/                     /*that's the end of the players. */
   end       /*game*/

say; say; say; say;  say center(''name.j "won! ",sw,'═');  say; say; exit
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1 then return arg(3); return word(arg(2) 's',1)  /*plural?*/
/*──────────────────────────────────SCRUTINIZE subroutine───────────────*/
scrutinize: parse arg ?,what,min,max   /*? is the number, or maybe not. */
if ?==''  |  ?==','  then return arg(5)
if \datatype(?,'N')  then call err what "isn't numeric: "    ?;      ?=?/1
if \datatype(?,'W')  then call err what "isn't an integer: " ?
if ?==0 & min>0      then call err what "can't be zero."
if ?<min             then call err what "can't be less than" min': '     ?
if ?==0 & max>0      then call err what "can't be zero."
if ?>max & max\==0   then call err what "can't be greater than" max': '  ?
return ?
/*──────────────────────────────────what2do subroutine──────────────────*/
what2do: parse arg who                 /*"who" is a human or a computer.*/
if j>hp & s.j+in.j>=win    then  return 1    /*an  easy choice  for HAL.*/
if j>hp &     in.j>=win%4  then  return 1    /*a simple stategy for HAL.*/
if j>hp                    then  return 0    /*HAL says, keep truckin'! */
say @ name.who', what do you want to do?     (a QUIT will stop the game),'
say @ 'press  ENTER  to roll again,  or anything else to STOP rolling.'
pull action;  action=space(action)     /*remove any superfluous blanks. */
if \abbrev('QUIT',action,1) then return action\==''
say; say;  say;  say center(' quitting. ',sw,'─');  say;  say;  say;  exit
/*───────────────────────────────error handling subroutines and others.─*/
err: say; say; say center(' error! ',max(40,linesize()%2),"*"); say
               do j=1 for arg(); say arg(j); say; end; say; exit 13

novalue: syntax: call err 'REXX program' condition('C') "error",,
             condition('D'),'REXX source statement (line' sigl"):",,
             sourceline(sigl)
