/*REXX program displays Conway's game of life, it stops after N repeats.*/
signal on halt                         /*handle cell growth interruptus.*/
parse arg peeps  '(' rows cols empty life! clearScreen repeats generations
       rows = p(rows               3)  /*the maximum number of cell rows*/
       cols = p(cols               3)  /* "     "       "    "   "  cols*/
      emp = pickChar(empty 'blank')    /*an empty cell character (glyph)*/
   clearScr = p(clearScreen        0)  /*1 indicates to clear the screen*/
clearscr=1
clearscr=0
      life! = pickChar(life!     '☼')  /*the gylph looks like an ameba. */
       reps = p(repeats            2)  /*stop if there are   2  repeats.*/
generations = p(generations      100)  /*number of generations allowed. */
usw=max(linesize()-1,cols)             /*usable screen width for display*/
#reps=0;         $.=emp                /*the universe is new, and barren*/
gens=abs(generations)                  /*use this for convenience.      */
x=space(peeps);  upper x               /*elide superfluous spaces; upper*/
if x==''  then x='BLINKER'             /*if none specified, use BLINKER.*/
if x=='BLINKER'  then x='2,1 2,2 2,3'
if x=='GLIDER'   then x='48,11 48,12 48,13 49,13 50,12'
if x=='OCTAGON'  then x='1,5 1,6 2,4 2,7 3,3 3,8 4,2 4,9 5,2 5,9 6,3 6,8 7,4 7,7 8,5 8,6'
call assign.                           /*assign the initial state cells.*/
call showCells                         /*show initial state of the cells*/
                                       /* [↓]  cell colony grow/live/die*/
     do life=1  for gens; call assign@ /*construct the next generation. */
     if generations>0 | life==gens  then call showCells    /*display it?*/
     end   /*life*/
fin: exit                              /*stick a fork in it, we're done.*/
/*───────────────────────────────SHOWCELLS subroutine───────────────────*/
showCells: if clearScr  then 'CLS'     /*  ◄─── change this for your OS.*/
call showRows                          /*show the rows in proper order. */
say right(copies('▒',usw) life,usw)    /*show fence between generations.*/
if _==''  then call fin                /*if no life,  then stop the run.*/
if !._    then #reps=#reps+1           /*we detected a repeated pattern.*/
!._=1                                  /*existence state & compare later*/
if reps\==0 & #reps<=reps  then return /*so far, so good regarding reps.*/
say;  say '  "Life" repeated itself'  reps  "times, simulation has ended."
call fin                               /*stick a fork in it, we're done.*/
/*───────────────────────────────1─liner subroutines───────────────────────────────────────────────────────────────────────*/
$:         parse arg _row,_col;            return $._row._col==life!
assign$:   do r=1  for rows;  do c=1  for cols;   $.r.c=@.r.c;  end;  end;      return
assign.:   do while x\==''; parse var x r ',' c x; $.r.c=life!; rows=max(rows,r); cols=max(cols,c); end; life=0; !.=0; return
assign?:   ?=$.r.c; n=neighbors(); if ?==emp then do;if n==3 then ?=life!; end; else if n<2 | n>3 then ?=emp; @.r.c=?; return
assign@:   @.=emp;      do r=1  for rows;  do c=1  for cols;  call assign?;  end;  end;           call assign$;        return
halt:      say;    say 'REXX program halted.';     say;   exit 0
neighbors: rm=r-1;  rp=r+1;  cm=c-1;  cp=c+1;      return $(rm,cm)+$(rm,c)+$(rm,cp)+$(r,cm)+$(r,cp)+$(rp,cm)+$(rp,c)+$(rp,cp)
p:         return word(arg(1),1)
pickChar:  _=p(arg(1)); arg u .; if u=='BLANK' then _=' '; L=length(_); if L==3 then _=d2c(_);if L==2 then _=x2c(_); return _
showRows:  _=; do r=rows by -1 for rows; z=; do c=1 for cols; z=z||$.r.c; end; z=strip(z,'T',emp); say z; _=_||z; end; return
