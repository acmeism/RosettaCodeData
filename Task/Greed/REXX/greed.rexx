/*REXX program lets a user play the game of  GREED  (by Matthew Day)  from the console. */
parse arg sw sd @ b ?r .                         /*obtain optional argumenst from the CL*/
if sw=='' | sw==","   then sw= 79                /*cols specified?  Then use the default*/
if sd=='' | sd==","   then sd= 22                /*rows     "         "   "   "     "   */
if  @=='' |  @==","   then @= '@'                /*here     "         "   "   "     "   */
if  b=='' |  b==","   then b= ' '                /*blank    "         "   "   "     "   */
if datatype(?r, 'W')  then call random ,,?r      /*maybe use a  seed  for the RANDOM BIF*/
if length(@)==2 & datatype(@,'X')  then @=x2c(@) /*maybe use @  char for current pos.   */
if length(b)==2 & datatype(b,'X')  then b=x2c(b) /*  "    "  B  char for background.    */
signal on halt                                   /*handle pressing of  Ctrl-Break  key. */
call init                                        /* [↓]  CLR  is reset if there's an err*/
clr=1;    do  until  # == sw*sd;        ??=      /*keep playing until the grid is blank.*/
          call show clr                          /*show the playing field (grid) to term*/
          call ask;                  clr= 1      /*obtain user's move, validate, or quit*/
          if \move()  then do;       clr= 0      /*perform the user's move per @ loc.*/
                           if ??==@. then say ____  "invalid move:  moving out of bounds."
                           if ??==b  then say ____  "invalid move:  moving into a blank."
                           end
          call show 0
          end   /*until*/                        /* [↑]  Also, if out─of─bounds, LEAVE. */
      if show(1)==sw*sd  then say ____ "You've won, the grid is blank,  your score is: " #
      exit  2
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ask:      do forever                             /*play 'til done, or no possible moves.*/
          say  ____  'moves:'  ____  '   Q= ◄↑   W= ↑    E= ►↑'
          say  ____  'moves:'  ____  '   A= ◄            D= ►'
          say  ____  'moves:'  ____  '   Z= ◄↓   X= ↓    C= ►↓'
          say  ____
          say  ____ 'enter a move     ──or──     QUIT          (the score is: '   #")"
          parse pull  z  2  1  what  .  1  oz;                   upper z what
          if abbrev('QUIT', what, 2) | abbrev("QQUIT", what, 2)  then leave
          if length( space(oz) )==1  &  pos(z, 'QWEADZXC')\==0   then return
          say ____ '***error*** invalid direction for a move:'  space(oz);            say
          end   /*forever*/
halt: say;      say ____ 'quitting.';           exit 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
init: @.= 'ff'x;  $.=.;     ____= copies("─", 8) /*out─of─bounds literal; fence for SAYs*/
          do   r=1  for sd
            do c=1  for sw;  @.r.c= random(1, 9) /*assign grid area to random digs (1►9)*/
            end   /*c*/
          end     /*r*/
      !r= random(1, sd);  !c= random(1, sw);  @.!r.!c= @;   return /*assign 1st position*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
move: @.!r.!c= '≤';   $r= !r;   $c= !c;    ??=   /*blank out this  "start"  position.   */
      @@=.                                       /*nullify the count of move positions. */
          do until @@==0;       select
                                when z== 'Q'  then do;   !r= !r - 1;    !c= !c - 1;    end
                                when z== 'W'  then       !r= !r - 1
                                when z== 'E'  then do;   !r= !r - 1;    !c= !c + 1;    end
                                when z== 'A'  then                      !c= !c - 1
                                when z== 'D'  then                      !c= !c + 1
                                when z== 'Z'  then do;   !r= !r + 1;    !c= !c - 1;    end
                                when z== 'X'  then       !r= !r + 1
                                when z== 'C'  then do;   !r= !r + 1;    !c= !c + 1;    end
                                end   /*select*/
          ?= @.!r.!c;    if ?==@. | ?==b  then do;  !r= $r;   !c= $c;   ??= ?;   return 0
                                               end
          if @@==.  then @@=?;   if datatype(@@, 'W')  then @@= @@ - 1   /*diminish cnt.*/
          @.!r.!c= '±'                           /*nullify  (later, a blank)  position. */
          end   /*until*/
      @.!r.!c= @;                    return 1    /*signify current grid position with @ */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: arg tell;     #=0;         if tell  then do;   "CLS";    say left('', !c)"↓";    end
          do   r=1  for sd;            _= ' '    /* [↑]  DOS cmd  CLS  clears the screen*/
            do c=1  for sw                       /*construct row of the grid for display*/
            if @.r.c=="±" & ??\==''  then @.r.c= $.r.c  /*Is this a temp blank?  Restore*/
            if @.r.c=="±" & ?? ==''  then @.r.c= b      /*Is this a temp blank?  Blank. */
            if @.r.c=="≤" & ??\==''  then @.r.c= $.r.c  /*Is this a temp a  @ ?  Restore*/
            if @.r.c=="≤" & ?? ==''  then @.r.c= b      /*Is this a temp a  @ ?  Blank. */
            ?= @.r.c;                _= _ || ?   /*construct a line of the grid for term*/
            if ?==b | ?==@  then #= # + 1        /*Position==b ─or─ @?  Then bump score.*/
            if tell         then $.r.c= @.r.c    /*create a backup grid for re─instating*/
            end   /*c*/
          if r==!r  then _= _ '◄'                /*indicate   row  of current position. */
          if tell   then say _                   /*display   a row of grid to screen.   */
          end     /*r*/; say;        return #    /*SHOW also counts # of blanks (score).*/
