/*REXX program plays  Penney's Game, a 2-player coin toss sequence game.*/
__=copies('─',9)                       /*literal for eyecatching fence. */
signal on halt                         /*a clean way out if CLBF quits. */
parse arg # ? .                        /*get optional args from the C.L.*/
if #==''  | #==","   then #=3          /*default coin sequence length.  */
if ?\=='' & ?\==','  then call random ,,?     /*use seed for RANDOM #s ?*/
wins=0;    do games=1                  /*play a number of Penney's games*/
           call game                   /*play a single inning of a game.*/
           end   /*games*/             /*keep at it 'til  QUIT  or halt.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one-line subroutines────────────────*/
halt:   say;   say __  "Penney's Game was halted.";   say;   exit 13
r: arg ,$;       do  arg(1);    $=$||random(0,1);  end;           return $
s: if arg(1)==1  then return arg(3); return word(arg(2) 's',1)  /*plural*/
/*──────────────────────────────────GAME subroutine─────────────────────*/
game:  @.=;  tosses=@.                 /*the coin toss sequence so far. */
toss1=r(1)                             /*result:   0=computer,   1=CBLF.*/
if \toss1  then call randComp          /*maybe let the computer go first*/
if  toss1  then say __ "You win the first toss, so you pick your sequence first."
           else say __ "The computer won first toss, the pick was: " @.comp
                call prompter          /*get the human's guess from C.L.*/
                call randComp          /*get computer's guess if needed.*/
                                       /*CBLF:  carbon-based life form. */
say __  "      your pick:"  @.CBLF     /*echo human's pick to terminal. */
say __  "computer's pick:"  @.comp     /*  "  comp.'s   "   "     "     */
say                                    /* [↓]  flip the coin 'til a win.*/
      do  flips=1  until pos(@.CBLF,tosses)\==0  |  pos(@.comp,tosses)\==0
      tosses=tosses || translate(r(1),'HT',10)
      end   /*flips*/                  /* [↑]   this is a flipping coin,*/
                                                 /* [↓] series of tosses*/
say __ "The tossed coin series was: "  tosses    /*show the coin tosses.*/
say
@@@="won this toss with "   flips   ' coin tosses.'     /*handy literal.*/
if pos(@.CBLF,tosses)\==0  then do;  say __  "You"  @@@;  wins=wins+1; end
                           else      say __  "The computer"  @@@
_=wins;  if _==0  then _='no'                      /*use gooder English.*/
say __ "You've won"  _  "game"s(wins)  'out of ' games"."
say;  say copies('╩╦',79%2)'╩';  say               /*show eyeball fence.*/
return
/*──────────────────────────────────PROMPTER subroutine─────────────────*/
prompter:  oops=__ 'Oops!  ';  a=      /*define some handy REXX literals*/
@a_z='ABCDEFG-IJKLMNOPQRS+UVWXYZ'      /*the extraneous alphabetic chars*/
p=__ 'Pick a sequence of'  #  "coin tosses of  H or T (Heads or Tails) or Quit:"
          do  until  ok;   say;  say p;  pull a  /*uppercase the answer.*/
          if abbrev('QUIT',a,1)  then exit 1     /*human wants to quit. */
          a=space(translate(a,,@a_z',./\;:_'),0) /*elide extraneous chrs*/
          b=translate(a,10,'HT');    L=length(a) /*tran───►bin; get len.*/
          ok=0                                   /*response is OK so far*/
              select                             /*verify user response.*/
              when \datatype(b,'B') then say oops "Illegal response."
              when \datatype(a,'M') then say oops "Illegal characters in response."
              when L==0             then say oops "No choice was given."
              when L<#              then say oops "Not enough coin choices."
              when L>#              then say oops "Too many coin choices."
              when a==@.comp        then say oops "You can't choose the computer's choice: " @.comp
              otherwise         ok=1
              end   /*select*/
          end       /*until ok*/
@.CBLF=a;           @.CBLF!=b          /*we have the human's guess now. */
return
/*──────────────────────────────────RANDCOMP subroutine─────────────────*/
randComp: if @.comp\==''  then return  /*the computer already has a pick*/
_=@.CBLF!                              /* [↓] use best-choice algorithm.*/
if _\==''  then g=left((\substr(_,min(2,#),1))left(_,1)substr(_,3),#)
  do  until g\==@.CBLF!;  g=r(#);  end /*otherwise, generate a choice.  */
@.comp=translate(g,'HT',10)
return
