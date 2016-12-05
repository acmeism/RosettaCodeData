/*REXX program grows and displays a forest (with growth  and fires caused by lightning).*/
signal on halt                                   /*handle any forest life interruptus.  */
parse value scrSize()  with  sd sw .             /*the size of the terminal display.    */
parse arg generations birth lightning randSeed . /*obtain the optional arguments from CL*/
if randSeed\==''  then call random ,,randSeed    /*do we want  RANDOM BIF repeatability?*/
generations = p(generations  100)                /*maybe use  one hundred  generations. */
      birth = p(strip(birth    , ,'%') 50 ) *100 /*calculate the percentage for births. */
  lightning = p(strip(lightning, ,'%') 1/8) *100 /*    "      "       "      " lightning*/
clearScreen = 1                                  /*(or 0)  ─── uses CLS (a DOS command).*/
      bare! = ' '                                /*the glyph used to show a bare place. */
      fire! = '▒'                                /*glyph is close to a conflagration.   */
      tree! = '18'x                              /*this is an up─arrow [↑] glyph (tree).*/
       rows = max(12, sd-2)                      /*shrink the usable screen rows by two.*/
       cols = max(79, sw-1)                      /*   "    "     "      "   cols  " one.*/
      every = 999999999                          /*shows a snapshot every Nth generation*/
      field = min(100000, rows*cols)             /*the size of the forest area (field). */
$.=bare!                                         /*forest:  it is now a treeless field. */
@.=$.                                            /*ditto,   for the  "shadow"   forest. */
gens=abs(generations)                            /*use this for convenience.            */
              /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒observe the forest grow and/or burn. */
  do  life=1  for gens                           /*simulate a forest's life cycle.      */
    do   r=1  for rows;     rank=bare!           /*start a forest rank as being bare.   */
      do c=2  for cols;     ?=substr($.r, c, 1);              ??=?
        select                                   /*select the most likeliest choice 1st.*/
        when ?==tree!  then  if ignite?()                then ??=fire!     /*on fire ?  */
        when ?==bare!  then  if random(1, field)<=birth  then ??=tree!     /*new growth.*/
        otherwise                                             ??=bare!     /*it's baren.*/
        end   /*select*/                         /* [↑]  when (↑)  if  ≡  short circuit.*/
      rank=rank || ??                            /*build rank:  1 forest "row" at a time*/
      end     /*c*/                              /*ignore column one, start with col two*/
    @.r=rank                                     /*and assign rank to alternate forest. */
    end       /*r*/                              /* [↓]  ··· and, later, yet back again.*/

      do r=1  for rows;  $.r=@.r;  end  /*r*/    /*assign alternate cells ──► real cells*/
  if life//every==0 | generations>0 | life==gens     then  call showForest
  end         /*life*/
              /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒stop observing the forest evolve.    */
halt: if life-1\==gens  then say 'Forest simulation interrupted.' /*was this pgm HALTed?*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ignite?: if substr($.r,c+1,1)==fire!  then return 1                 /*is  east on fire? */
         if substr($.r,c-1,1)==fire!  then return 1                 /* "  west  "   "   */
                cm=c-1;         rm=r-1;            rp=r+1           /*curr. row offsets.*/
         if pos(fire!, substr($.rm, cm, 3)substr($.rp, cm,3))\==0  then return 1
         return  random(1, field) <= lightning                      /*lightning ignition*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
p:       return word(arg(1), 1)                  /*pick─a─word:  first  or  second word.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
showForest: if clearScreen  then 'CLS'           /*  ◄───change this command for your OS*/
                  do r=rows  by -1  for rows     /*show the forest grid in proper order.*/
                  say strip(substr($.r, 2), 'T') /*be smart/neat about trailing blanks. */
                  end   /*r*/                    /* [↑]  that is to say,  remove them.  */
            say right(copies('▒',cols)life,cols) /*show and tell for a stand of trees.  */
            return
