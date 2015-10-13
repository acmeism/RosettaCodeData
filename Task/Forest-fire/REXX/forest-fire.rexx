/*REXX pgm grows and displays a forest (with growth and fires (lightning).
  ┌────────────────────────────elided version──────────────────────────┐
  ├──── original version has many more options & enhanced displays.────┤
  └────────────────────────────────────────────────────────────────────┘*/
signal on syntax;    signal on noValue /*handle run─time REXX pgm errors*/
signal on halt                         /*handle forest life interruptus.*/
parse value scrSize()  with  sd sw .   /*the size of the term. display. */
parse arg generations birth lightning randSeed .   /*get optional args. */
if randSeed\==''  then call random ,,randSeed      /*want repeatability?*/
generations = p(generations  100)      /*maybe use 100 generations.     */
      birth = p(strip(birth    , ,'%')  50 )  * 100    /*calculate the %*/
  lightning = p(strip(lightning, ,'%')  1/8)  * 100    /*    "      "  "*/
clearScreen = 1                        /*(or 0)  ─── uses CLS  (DOS cmd)*/
     forest = 100**2                   /* "    "   "  "  forest (field).*/
      bare! = ' '                      /*glyph used to show a bare place*/
      fire! = '▒'                      /*well,  close to a fire glyph.  */
      tree! = '18'x                    /*this is an up─arrow [↑]  glyph.*/
       rows = max(12, sd-2)            /*shrink the screen rows by two. */
       cols = max(79, sw-1)            /*   "    "     "   cols  " one. */
      every = 999999999                /*shows a snapshot every Nth time*/
$.=bare!                               /*forest:  now a treeless field. */
@.=$.                                  /*ditto,   the "shadow"  forest. */
gens=abs(generations)                  /*use this for convenience.      */
/*═════════════════════════════════════watch the forest grow and/or burn*/
  do  life=1  for gens                 /*simulate a forest's life cycle.*/
    do   r=1  for rows;     rank=bare! /*start a rank with it being bare*/
      do c=2  for cols;     ?=substr($.r,c,1);                ??=?
        select                         /*select da quickest choice first*/
        when ?==tree!  then  if ignite?()                then ??=fire!
        when ?==bare!  then  if random(1,forest)<=birth  then ??=tree!
        otherwise         /*it's bare.*/                      ??=bare!
        end   /*select*/               /* [↑]  when┼if ≡ short circuit. */
      rank=rank || ??                  /*build rank: 1 thingy at a time.*/
      end     /*c*/                    /*ignore column 1, start with 2. */
    @.r=rank                           /*and assign to alternate forest.*/
    end       /*r*/                    /* [↓]  ···and, later, back again*/

      do r=1  for rows;  $.r=@.r;  end /*assign alternate cells ──► real*/
  if life//every==0 | generations>0 | life==gens     then  call showForest
  end         /*life*/
/*═════════════════════════════════════stop watching the forest grow.   */
halt: if life-1\==gens  then say 'REXX program interrupted.'   /*HALTed?*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────SHOWFOREST subroutine──────────────────*/
showForest: if clearScreen  then 'CLS' /*  ◄─── change this for your OS.*/
      do r=rows  by -1  for rows       /*show the forest in proper order*/
      say strip(substr($.r,2),'T')     /*be neat about trailing blanks. */
      end   /*r*/                      /* [↑]  that's to say, remove 'em*/
say right(copies('═',cols)life, cols)  /*show&tell for a stand of trees.*/
return
/*──────────────────────────────────IGNITE? subroutine──────────────────────*/
ignite?: if substr($.r,c+1,1)==fire!  then return 1     /*is  east on fire? */
         if substr($.r,c-1,1)==fire!  then return 1;    /* "  west  "   "   */
                  rp=r+1;   rm=r-1                      /*curr. row offsets.*/
         if pos(fire!,substr($.rm,c-1,3)substr($.rp,c-1,3))\==0  then return 1
         return  random(1,forest)<=lightning
/*───────────────────────────────1─liner subroutines─────────────────────────────────────────────────────────────────────────────────*/
err:      say;  say;  say center(' error! ',max(40,sw%2),"*");  say;     do _=1  for arg();  say arg(_);  say;  end;      say;  exit 13
noValue:  syntax: call err 'REXX program' condition('C') "error",condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
p:        return word(arg(1),1)        /*pick─a─word:  first or second word.*/
