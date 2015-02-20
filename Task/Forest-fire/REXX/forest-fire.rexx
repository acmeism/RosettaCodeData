/*REXX program grows and displays a forest  (with growth and lightning).
   ┌───────────────────────────elided version─────────────────────────┐
   ├─── full version has many more options and enhanced displays. ────┤
   └──────────────────────────────────────────────────────────────────┘ */
signal on syntax;  signal on novalue   /*handle REXX program errors.    */
signal on halt                         /*handle growth interruptus.     */
_=                                     /*(below) nullify some options.  */
parse var _ generations rows cols birth lightning bare! fire! tree!,
            randseed clearscreen every
if randseed\=='' then call random ,,randseed
    percent = 100                      /*handy-dandy constant for using%*/
      field = percent**2               /*size of the probability field. */
      blank = 'BLANK'
generations = p(generations            100)
       rows = p(rows                   word(scrsize(),1)-2)
       cols = p(cols                   max(79,linesize())-1)
      bare! = pickchar(bare!           blank)
      fire! = pickchar(fire!           '▒')
      tree! = pickchar(tree!           '18'x)
clearscreen = p(clearscreen            1)
      every = p(every                  999999999)
      birth = p(strip(birth,,'%')      50 )*percent
  lightning = p(strip(lightning,,'%')  1/8)*percent
$.=bare!                               /*the forest is a treeless field.*/
@.=bare!                               /*also, the alternate universe.  */
gens=abs(generations)                  /*use this for convenience.      */
/*═════════════════════════════════════watch the forest grow and/or burn*/
  do  life=1  for gens                 /*process a forest life cycle.   */
    do   r=1  for rows;     rank=bare!
      do c=2  for cols;     ?=substr($.r,c,1);                ??=?
        select                         /*select da quickest choice first*/
        when ?==tree!  then  if ignite?()               then ??=fire!
        when ?==bare!  then  if random(1,field)<=birth  then ??=tree!
        otherwise          /*fire*/                          ??=bare!
        end   /*select*/
      rank=rank || ??
      end     /*c*/                     /*ignore column 1, start with 2.*/
    @.r=rank
    end       /*r*/

      do r=1  for rows;  $.r=@.r;  end /*assign alternate cells ──► real*/
  if life//every==0 | generations>0 | life==gens     then  call showForest
  end         /*life*/
/*═════════════════════════════════════stop watching the forest grow.   */
halt: cycles=life-1; if cycles\==gens then say 'REXX program interrupted.'
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────SHOWFOREST subroutine──────────────────*/
showForest: if clearscreen  then 'CLS' /*  ◄─── change this for your OS.*/
      do r=rows  by -1  for rows       /*show the forest in proper order*/
      say strip(substr($.r,2),'T')     /*be neat about trailing blanks. */
      end   /*r*/
say right(copies('═',cols)life, cols)  /*show&tell for a stand of trees.*/
return
/*──────────────────────────────────IGNITE? subroutine──────────────────*/
ignite?: if substr($.r,c+1,1)==fire!  then return 1     /*east on fire ?*/
         if substr($.r,c-1,1)==fire!  then return 1;    rp=r+1;   rm=r-1
cm=c-1;  if pos(fire!,substr($.rm,cm,3)substr($.rp,cm,3))\==0  then return 1
return  random(1,field) <= lightning
/*───────────────────────────────1─liner subroutines─────────────────────────────────────────────────────────────────────────────────*/
err:      say;say;say center(' error! ',max(40,linesize()%2),"*");say;do j=1 for arg();say arg(j);say;end;say;exit 13
novalue:  syntax: call err 'REXX program' condition('C') "error",condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
pickchar: _=p(arg(1));if translate(_)==blank then _=' ';if length(_) ==3 then _=d2c(_);if length(_) ==2 then _=x2c(_);return _
p:        return word(arg(1),1)
