/*REXX program presents a  "flipping bit"  puzzle.  The user can solve via it via  C.L. */
parse arg  N u on off .                          /*get optional arguments from the C.L. */
if N=='' | N==","  then N  =3                    /*Size given?   Then use default of  3.*/
if u=='' | u==","  then u  =N                    /*the number of bits initialized to ON.*/
if on ==''         then on =1                    /*the character used for   "on".       */
if off==''         then off=0                    /* "      "       "   "   "off".       */
col@= 'a b c d e f g h i j k l m n o p q r s t u v w x y z'         /*for the column id.*/
cols=space(col@,0);     upper cols               /*letters to be used for the columns.  */
@.=off;  !.=off                                  /*set both arrays to  "off" characters.*/
tries=0                                          /*number of player's attempts (so far).*/
         do  while  show(0) < u                  /* [↓]   turn  "on"  U  number of bits.*/
         r=random(1,N);  c=random(1,N)           /*get a random  row  and  column.      */
         @.r.c=on     ;  !.r.c=on                /*set (both)  row and column  to ON.   */
         end   /*while*/                         /* [↑]  keep going 'til   U   bits set.*/
oz=z                                             /*keep the original array string.      */
call show 1, '   ◄───target'                     /*show target for user to attain.      */

       do random(1,2); call flip 'R',random(1,N) /*flip a   row    of bits.             */
                       call flip 'C',random(1,N) /*  "  "  column   "   "               */
       end   /*random···*/                       /* [↑]  just perform  1  or  2  times. */

if z==oz  then call flip 'R',random(1,N)         /*ensure it's not target we're flipping*/

       do  until  z==oz                          /*prompt until they get it right.      */
       call prompt                               /*get a row or column number from C.L. */
       call flip left(?,1),substr(?,2)           /*flip a user selected row or column.  */
       call show 0                               /*get image (Z) of the updated array.  */
       end   /*until···*/

call show 1, '   ◄───your array'                 /*display the array to the terminal.   */
say '─────────Congrats!    You did it in'     tries     "tries."
exit tries                                       /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
halt:  say 'program was halted!';   exit         /*the REXX program was halted by user. */
isInt: return datatype(arg(1),'W')               /*returns   1   if  arg  is an integer.*/
isLet: return datatype(arg(1),'M')               /*returns   1   if  arg  is a letter.  */
terr:  if ok  then say  '***error!***:  illegal'  arg(1);           ok=0;           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
flip: parse arg x,#                              /*X  is  R  or  C;    #:  is which one.*/
             do c=1  for N  while x=='R'; if @.#.c==on  then @.#.c=off; else @.#.c=on; end
             do r=1  for N  while x=='C'; if @.r.#==on  then @.r.#=off; else @.r.#=on; end
      return                                     /* [↑]  the bits can be  ON  or  OFF.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
prompt: if tries\==0  then  say '─────────bit array after play: '         tries
        signal on halt                           /*another method for the player to quit*/
        !='─────────Please enter a  row number  or  column letter,    or  Quit:'
        call show 1, '   ◄───your array'         /*display the array to the terminal.   */

           do forever;  ok=1;  say;   say !;   pull ? _ . 1 all       /*prompt & get ans*/
           if abbrev('QUIT',?,1)      then do; say 'quitting···';  exit 0;  end
           if ?==''                   then do; call show 1,"   ◄───target",.;    ok=0
                                               call show 1,"   ◄───your array"
                                           end                        /* [↑] reshow targ*/
           if _\==''                  then call terr 'too many args entered:'   all
           if \isInt(?) & \isLet(?)   then call terr 'row/column: '  ?
           if isLet(?)                then a=pos(?,cols)
           if isLet(?) & (a<1 | a>N)  then call terr 'column: '      ?
           if isLet(?) & length(?)>1  then call terr 'column: '      ?
           if isLet(?)                then ?='C'pos(?,cols)
           if isInt(?) & (?<1 | ?>N)  then call terr 'row: '         ?
           if isInt(?)                then ?=?/1                      /*normalize number*/
           if isInt(?)                then ?='R'?
           if ok                      then leave                      /*No errors? Leave*/
           end   /*forever*/                                          /*end of da checks*/

        tries=tries+1                                                 /*bump da counter.*/
        return ?                                                      /*return response.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: $=0;     _=;      z=;         parse arg tell,tx,o               /*$: # of ON bits.*/
      if tell  then do; say                                           /*are we telling? */
                        say '     ' subword(col@,1,N) "  column letter"
                        say 'row ╔'copies('═',N+N+1)                  /*prepend col hdrs*/
                    end                                               /* [↑]  grid hdrs.*/

        do   r=1  for N                                               /*show  grid rows.*/
          do c=1  for N                                               /*build grid cols.*/
          if o==.  then do;  z=z || !.r.c;   _=_ !.r.c;   $=$+(!.r.c==on);   end
                   else do;  z=z || @.r.c;   _=_ @.r.c;   $=$+(@.r.c==on);   end
          end   /*c*/                                                 /*··· and sum ONs.*/
        if tx\==''  then tar.r=_ tx                                   /*build da target?*/
        if tell     then say right(r,2) ' ║'_ tx;          _=         /*show the grid?  */
        end     /*r*/                                                 /*show a grid row.*/

      if tell  then say                                               /*show blank line.*/
      return $                                                        /*$: # of ON bits.*/
