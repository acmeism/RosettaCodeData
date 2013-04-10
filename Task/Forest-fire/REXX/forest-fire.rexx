/*REXX program grows and displays a forest  (with growth and lightning).
   ┌───────────────────────────elided version─────────────────────────┐
   ├─── full version has many more options and enhanced displays. ────┤
   └──────────────────────────────────────────────────────────────────┘ */
signal on syntax;  signal on novalue   /*handle REXX program errors.    */
signal on halt                         /*handle cell growth interruptus.*/
parse arg peeps '(' generations rows cols bare! life! clearscreen every
@abc='abcdefghijklmnopqrstuvwxyz'; @abcU=@abc; upper @abcU
      blank = 'BLANK'
generations = p(generations            100)
       rows = p(rows                   3)
       cols = p(cols                   3)
      bare! = pickchar(bare!           blank)
clearscreen = p(clearscreen            0)
      every = p(every                  999999999)
      life! = pickchar(life!           '☼')
fents=max(79,cols)                     /*fence width shown after display*/
$.=bare!                               /*the universe is new, and barren*/
gens=abs(generations)                  /*use this for convenience.      */
x=space(peeps)                         /*remove superfluous spaces.     */
if x=='' then x='2,1 2,2 2,3'

        do  while x \==''
        parse var x p x; parse var p r ',' c .; $.r=overlay(life!,$.r,c+1)
        end
life=0;     !.=0;    call showCells    /*show initial state of the cells*/
/*─────────────────────────────────────watch cell colony grow/live/die. */
  do  life=1 for gens
    do   r=1 for rows;     rank=bare!
      do c=2 for cols;     ?=substr($.r,c,1);       ??=?;    n=neighbors()
          select                       /*select da quickest choice first*/
          when ?==bare!    then  if n==3       then ??=life!
          otherwise              if n<2 | n>3  then ??=bare!
          end   /*select*/
      rank=rank || ??
      end       /*c*/
    @.r=rank
    end         /*c*/

       do r=1 for rows; $.r=@.r; end   /*assign alternate cells ──► real*/
  if life//every==0 | generations>0 | life==gens then call showCells
  end           /*life*/
/*─────────────────────────────────────stop watching the universe (life)*/
halt: cycles=life-1; if cycles\==gens then say 'REXX program interrupted.'
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────SHOWCELLS subroutine─-─────────────────*/
showCells: if clearscreen then 'CLS'   /*  ◄─── change this for your OS.*/
_=;   do r=rows  by -1  for rows       /*show the forest in proper order*/
      z=strip(substr($.r,2),'T')       /*pick off the meat of the row.  */
      say z;   _=_ || z                /*be neat about trailing blanks. */
      end   /*r*/
say right(copies('═',fents)life,fents) /*show&tell for a stand of trees.*/
if _=='' then exit                     /*if no life, then stop the run. */
if !._   then do;   say 'repeating ...';    exit;   end
!._=1                                  /*assign a state & compare later.*/
return
/*───────────────────────────────NEIGHBORS subroutine───────────────────*/
neighbors: rp=r+1; cp=c+1; rm=r-1; cm=c-1  /*count 8 neighbors of a cell*/
return    (substr($.rm,cm,1)==life!)   +   (substr($.rm,c ,1)==life!)  + ,
          (substr($.rm,cp,1)==life!)   +   (substr($.r ,cm,1)==life!)  + ,
          (substr($.r ,cp,1)==life!)   +   (substr($.rp,cm,1)==life!)  + ,
          (substr($.rp,c ,1)==life!)   +   (substr($.rp,cp,1)==life!)
/*───────────────────────────────1-liner subroutines────────────────────*/
err:      say;say;say center(' error! ',max(40,linesize()%2),"*");say;do j=1 for arg();say arg(j);say;end;say;exit 13
novalue:  syntax: call err 'REXX program' condition('C') "error",condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
pickchar: _=p(arg(1));if translate(_)==blank then _=' ';if length(_) ==3 then _=d2c(_);if length(_) ==2 then _=x2c(_);return _
p:        return word(arg(1),1)
