/*REXX program  displays a   wire world  Cartesian grid   of  four─state  cells.        */
signal on halt                                   /*handle any cell growth interruptus.  */
parse arg  iFID .  '('  generations  rows  cols  bare  head  tail  wire  clearScreen  reps
if iFID==''  then iFID="WIREWORLD.TXT"           /*should default input file  be used?  */
      blank = 'BLANK'                            /*the "name" for a blank.              */
generations = p(generations     100   )          /*number generations that are allowed. */
       rows = p(rows            3     )          /*the number of cell  rows.            */
       cols = p(cols            3     )          /* "     "    "   "   columns.         */
       bare = pickChar(bare     blank )          /*an empty cell character.             */
clearScreen = p(clearScreen     0     )          /*1    means to clear the screen.      */
       head = pickChar(head     'H'   )          /*pick the character for the  head.    */
       tail = pickChar(wire     .     )          /*  "   "      "      "   "   wire.    */
       reps = p(reps            2     )          /*stop program  if there are 2 repeats.*/
fents=max(linesize()-1,cols)                     /*the fence width used after displaying*/
#reps=0;    $.=bare                              /*at start, universe is new and barren.*/
gens=abs(generations)                            /*use for convenience (and short name).*/
                                                 /* [↓]     read the input file.        */
         do r=1  while lines(iFID)\==0           /*keep reading until the  End─Of─File. */
         q=strip(linein(iFID), 'T')              /*get single line from the input file. */
         _=length(q)                             /*obtain the length of this (input) row*/
         cols=max(cols, _)                       /*calculate the maximum number of cols.*/
            do c=1  for _;  $.r.c=substr(q, c, 1);   end         /*assign the row cells.*/
         end   /*r*/
rows=r-1                                         /*adjust the row number (from DO loop).*/
life=0;      !.=0;          call showCells       /*display initial state of the cells.  */
                                                 /*watch cells evolve, 4 possible states*/
  do life=1  for gens;      @.=bare              /*perform for the number of generations*/

     do   r=1  for rows                          /*process each of the rows.            */
       do c=1  for cols;    ?=$.r.c;   ??=?      /*   "      "   "  "  columns.         */
                 select                          /*determine the type of cell.          */
                 when ?==head  then ??=tail
                 when ?==tail  then ??=wire
                 when ?==wire  then do;    n=hood();   if n==1 | n==2  then ??=head;   end
                 otherwise     nop
                 end   /*select*/
       @.r.c=??
       end             /*c*/
     end               /*r*/

  call assign$                                   /*assign alternate cells ──► real world*/
  if generations>0 | life==gens  then call showCells
  end   /*life*/
                                                 /*stop watching the universe (or life).*/
halt: if life-1\==gens  then say 'The  ~~~Wireworld~~~  program was interrupted.'
done: exit                                       /*stick a fork in it,  we are all done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
showCells: if clearScreen  then 'CLS'                       /*◄──change this for the OS.*/
           call showRows                                    /*show rows in proper order.*/
           say right(copies('═',fents)life,fents)           /*display a bunch of cells. */
           if _==''  then signal done                       /*No life?   Then stop run. */
           if !._    then #reps=#reps+1                     /*detected repeated pattern.*/
           !._=1                                            /*it is now existence state.*/
           if reps\==0 & #reps<=reps  then return           /*so far, so good, no reps. */
           say '"Wireworld" repeated itself' reps "times,  program is stopping."
           signal done                                      /*exit program, we're done. */
/*─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
$:         parse arg _row,_col;                      return ($._row._col==head)
assign$:   do r=1  for rows;   do c=1  for cols;     $.r.c=@.r.c;     end;    end;        return
err:       say; say center(' error! ',max(40,linesize()%2),"*"); say;  do j=1  for arg(); say arg(j); say; end;  say; exit 13
hood:      return $(r-1,c-1)  +  $(r-1,c)  +  $(r-1,c+1)  +  $(r,c-1)  +  $(r,c+1)  +  $(r+1,c-1)  +  $(r+1,c)  +  $(r+1,c+1)
p:         return word(arg(1), 1)
pickChar:  _=p(arg(1));if translate(_)==blank then _=' ';if length(_)==3 then _=d2c(_);if length(_)==2 then _=x2c(_);return _
showRows:  _=;   do r=1  for rows; z=;   do c=1 for cols; z=z || $.r.c; end;   z=strip(z,'T'); say z; _=_ || z; end;   return
