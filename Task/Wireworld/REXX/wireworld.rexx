/*REXX program displays a wire world cartesuab grid of four─state cells.*/
signal on halt                         /*handle cell growth interruptus.*/
parse arg iFID . '(' generations rows cols bare eHead eTail conductor clearScreen repeats
if iFID==''  then iFID='WIREWORLD.TXT' /*use the default file for input?*/
      blank = 'BLANK'                             /*the "name" for blank*/
generations = p(generations            100)       /*#generations allowed*/
       rows = p(rows                   3)         /*number of cell rows.*/
       cols = p(cols                   3)         /*   "    "   "  cols.*/
      bare = pickChar(bare             blank)     /*an empty cell thingy*/
clearScreen = p(clearScreen            0)         /*1 = clear the screen*/
     eHead = pickchar(eHead            'H')
     eTail = pickchar(eTail            't')
 conductor = pickchar(conductor         . )
    repeats = p(repeats                2)         /*stop if  2  repeats.*/
fents=max(linesize()-1,cols)           /*fence width shown after display*/
#repeats=0;   $.=bare                  /*the universe is new, and barren*/
gens=abs(generations)                  /*use this for convenience.      */
                                       /* [↓]     read the input file.  */
         do r=1  while lines(iFID)\==0 /*keep reading until end-of-file.*/
         q=strip(linein(iFID),'T')     /*get a single line from the file*/
         _=length(q)                   /*obtain the length of this row. */
         cols=max(cols,_)              /*calculate the maximum # of cols*/
            do c=1  for _; $.r.c=substr(q,c,1); end   /*assign row cells*/
         end   /*r*/
rows=r-1
cycle=0;      !.=0;    call showCells  /*show initial state of the cells*/
/*─────────────────────────────────────watch cells evolve 4 poss. states*/
  do cycle=1  for gens;      @.=bare
               do   r=1  for rows
                 do c=1  for cols;     ?=$.r.c;       ??=?
                   select
                   when ?==eHead       then ??=eTail
                   when ?==eTail       then ??=conductor
                   when ?==conductor   then do;       n=neighbors()
                                            if n==1 | n==2  then ??=eHead
                                            end
                   otherwise           nop
                   end   /*select*/
                 @.r.c=??
                 end       /*c*/
               end         /*r*/
  call assign$                         /*assign alternate cells ──► real*/
  if generations>0 | cycle==gens  then call showCells
  end   /*cycle*/
/*─────────────────────────────────────stop watching the universe (life)*/
halt: cycles=life-1; if cycles\==gens then say 'REXX program interrupted.'
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────SHOWCELLS subroutine───────────────────*/
showCells: if clearScreen  then 'CLS'  /*  ◄─── change this for your OS.*/
call showRows                          /*show the rows in proper order. */
say right(copies('═',fents)cycle,fents) /*show&tell for a bunch of cells*/
if _==''  then exit                    /*if no life, then stop the run. */
if !._    then #repeats=#repeats+1     /*we detected a repeated pattern.*/
!._=1                                  /*existence state & compare later*/
if repeats\==0 & #repeats<=repeats  then return       /*so far, so good.*/
say '"Wireworld" repeated itself'  repeats  "times,  program is stopping."
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────1─liner subroutines───────────────────────────────────────────────────────────────────────*/
$:         parse arg _row,_col;          return $._row._col==eHead
assign$:   do r=1 for rows; do c=1 for cols; $.r.c=@.r.c; end; end;  return
err:       say;say;say center(' error! ',max(40,linesize()%2),"*");say;do j=1 for arg();say arg(j);say;end;say;exit 13
neighbors: return $(r-1,c-1)+$(r-1,c)+$(r-1,c+1)+$(r,c-1)+$(r,c+1)+$(r+1,c-1)+$(r+1,c)+$(r+1,c+1)
p:         return word(arg(1),1)
pickChar:  _=p(arg(1));if translate(_)==blank then _=' ';if length(_)==3 then _=d2c(_);if length(_)==2 then _=x2c(_);return _
showRows:  _=;   do r=1  for rows; z=;   do c=1 for cols; z=z||$.r.c; end;   z=strip(z,'T'); say z; _=_||z; end;   return
