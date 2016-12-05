/*REXX program runs and displays the Conway's game of life, it stops after  N  repeats. */
signal on halt                                   /*handle a  cell growth  interruptus.  */
parse arg peeps  '(' rows  cols  empty  life!  clearScreen  repeats  generations .
       rows =        p(rows               3)     /*the maximum number of cell  rows.    */
       cols =        p(cols               3)     /* "     "       "    "   "  columns.  */
        emp = pickChar(empty        'blank')     /*an empty cell character  (glyph).    */
   clearScr =        p(clearScreen        0)     /* "1"   indicates to clear the screen.*/
      life! = pickChar(life!            '☼')     /*the gylph kinda looks like an amoeba.*/
       reps =        p(repeats            2)     /*stop pgm  if there are  two  repeats.*/
generations =        p(generations      100)     /*the number of  generations  allowed. */
sw=max(linesize()-1,cols)                        /*usable screen width for the display. */
#reps=0;         $.=emp                          /*the universe is new,  ··· and barren.*/
gens=abs(generations)                            /*used for a  programming  convenience.*/
x=space(peeps);  upper x                         /*elide superfluous spaces; uppercase. */
if x==''         then x="BLINKER"                /*if nothing specified,  use  BLINKER. */
if x=='BLINKER'  then x= "2,1 2,2 2,3"
if x=='OCTAGON'  then x= "1,5 1,6 2,4 2,7 3,3 3,8 4,2 4,9 5,2 5,9 6,3 6,8 7,4 7,7 8,5 8,6"
call assign.                                     /*assign the initial state of all cells*/
call showCells                                   /*show the  initial state of the cells.*/
                                                 /* [↓]  cell colony grows, lives, dies.*/
     do life=1  for gens;      call assign@      /*construct  next  generation of cells.*/
     if generations>0 | life==gens  then call showCells    /*should cells be displayed? */
     end   /*life*/
fin: exit                                        /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showCells: if clearScr  then 'CLS'               /*  ◄───  change 'command' for your OS.*/
           call showRows                         /*show the rows in the proper order.   */
           say right(copies('▒', sw)  life, sw)  /*show a fence between the generations.*/
           if _==''  then call fin               /*if there's no life, then stop the run*/
           if !._    then #reps=#reps+1          /*we detected a repeated cell pattern. */
           !._=1                                 /*existence  state and compare  later. */
           if reps\==0 & #reps<=reps then return /*so far, so good,   regarding repeats.*/
           say
           say center('"Life" repeated itself' reps "times, simulation has ended.",sw,'▒')
           call fin                              /*stick a fork in it,  we're all done. */
/*───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────*/
$:         parse arg _row,_col;                    return $._row._col==life!
assign$:   do r=1  for rows;   do c=1  for cols;   $.r.c=@.r.c;                                     end;    end;       return
assign.:   do while x\==''; parse var x r "," c x; $.r.c=life!; rows=max(rows,r); cols=max(cols,c); end; life=0; !.=0; return
assign?:   ?=$.r.c; n=neighbors(); if ?==emp then do;if n==3 then ?=life!; end; else if n<2 | n>3 then ?=emp; @.r.c=?; return
assign@:   @.=emp;      do r=1  for rows;  do c=1  for cols;  call assign?;  end;  end;            call assign$;       return
halt:      say;         say "REXX program  (Conway's Life)  halted.";    say;      exit 0
neighbors: return $(r-1,c-1)  +  $(r-1,c)  +  $(r-1,c+1)  +  $(r,c-1)  +  $(r,c+1)  +  $(r+1,c-1)  +  $(r+1,c)  +  $(r+1,c+1)
p:         return word(arg(1), 1)
pickChar:  _=p(arg(1)); arg u .; if u=='BLANK' then _=" "; L=length(_); if L==3 then _=d2c(_); if L==2 then _=x2c(_);  return _
showRows:  _=; do r=rows by -1 for rows; z=; do c=1 for cols; z=z||$.r.c; end; z=strip(z,'T',emp); say z; _=_||z; end; return
