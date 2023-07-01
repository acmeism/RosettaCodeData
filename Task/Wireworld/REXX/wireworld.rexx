/*REXX program  displays a   wire world   Cartesian grid   of  four─state  cells.       */
parse arg  iFID .  '('  generations  rows  cols  bare  head  tail  wire  clearScreen  reps
if iFID==''  then iFID= "WIREWORLD.TXT"          /*should default input file  be used?  */
        bla = 'BLANK'                            /*the "name" for a blank.              */
generations = p(generations     100   )          /*number generations that are allowed. */
       rows = p(rows            3     )          /*the number of cell  rows.            */
       cols = p(cols            3     )          /* "     "    "   "   columns.         */
       bare = pickChar(bare     bla   )          /*character used to show an empty cell.*/
clearScreen = p(clearScreen     0     )          /*1    means to clear the screen.      */
       head = pickChar(head     'H'   )          /*pick the character for the  head.    */
       tail = pickChar(tail     't'   )          /*  "   "      "      "   "   tail.    */
       wire = pickChar(wire     .     )          /*  "   "      "      "   "   wire.    */
       reps = p(reps            2     )          /*stop program  if there are 2 repeats.*/
fents= max(cols, linesize() - 1)                 /*the fence width used after displaying*/
#reps= 0;     $.= bare;   gens= abs(generations) /*at start, universe is new and barren.*/
                                                 /* [↓]     read the input file.        */
       do r=1  while lines(iFID)\==0             /*keep reading until the  End─Of─File. */
       q= strip( linein(iFID), 'T')              /*get a line from input file.          */
       L= length(q);      cols= max(cols, L)     /*calculate maximum number of columns. */
          do c=1  for L;  $.r.c= substr(q, c, 1) /*assign the cells for the   R   row.  */
          end   /*c*/
       end      /*r*/
!.= 0;                      signal on halt       /*initial state of cells;  handle halt.*/
rows= r - 1;   life= 0;     call showCells       /*display initial state of the cells.  */
                                                 /*watch cells evolve, 4 possible states*/
  do   life=1  for gens;    @.= bare             /*perform for the number of generations*/
     do   r=1  for rows                          /*process each of the rows.            */
       do c=1  for cols;    ?= $.r.c;    ??= ?   /*   "      "   "  "  columns.         */
                 select                          /*determine the type of cell.          */
                 when ?==head  then ??= tail
                 when ?==tail  then ??= wire
                 when ?==wire  then do;  #= hood();   if #==1 | #==2  then ??= head;   end
                 otherwise     nop
                 end   /*select*/
       @.r.c= ??                                 /*possible assign a  cell  a new state.*/
       end             /*c*/
     end               /*r*/

  call assign$                                   /*assign alternate cells ──► real world*/
  if generations>0 | life==gens  then call showCells
  end   /*life*/
                                                 /*stop watching the universe (or life).*/
halt: if life-1\==gens  then say 'The  ───Wireworld───  program was interrupted by user.'
done: exit 0                                     /*stick a fork in it,  we are all done.*/
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
$:         parse arg _row,_col;                  return  $._row._col==head
assign$:   do r=1  for rows;   do c=1  for cols;   $.r.c= @.r.c;   end;   end;      return
hood:      return  $(r-1,c-1)  + $(r-1,c)  + $(r-1,c+1)  + $(r,c-1)  + $(r,c+1)  + $(r+1,c-1)  + $(r+1,c)  + $(r+1,c+1)
p:         return word(arg(1), 1)                           /*pick the 1st word in list.*/
pickChar:  parse arg _ .;arg U .;L=length(_);if U==bla then _=' '; if L==3 then _=d2c(_);if L==2 then _=x2c(_);return _
showRows:  _=;  do r=1  for rows; z=;  do c=1 for cols; z= z||$.r.c; end;  z= strip(z,'T'); say z; _= _||z; end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showCells: if clearScreen  then 'CLS'                       /*◄──change CLS for the host*/
           call showRows                                    /*show rows in proper order.*/
           say right( copies('═', fents)life, fents)        /*display a title for cells.*/
           if _==''                   then signal done      /*No life?   Then stop run. */
           if !._                     then #reps= #reps + 1 /*detected repeated pattern.*/
           !._= 1                                           /*it is now an extant state.*/
           if reps\==0 & #reps<=reps  then return           /*so far, so good,  no reps.*/
           say '"Wireworld" repeated itself'    reps    "times,  the program is stopping."
           signal done                                      /*jump to this pgm's "exit".*/
