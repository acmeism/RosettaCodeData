/*REXX program implements Langton's ant walk and displays the ant's path*/
parse arg dir char .                   /*allow specification: ant facing*/
if char==''  then char='#'             /*binary colors: 0≡white, 1≡black*/
@.=0                                   /*define stem array  (all white).*/
Lb=1        ;  Rb=100                  /* left  boundry,  right boundry.*/
Bb=1        ;  Tb=100                  /*bottom    "        top    "    */
x=(Rb-Lb)%2 ;  y=(Tb-Bb)%2             /*approximate center (walk start)*/
if dir==''     then dir=random(1,4)    /*ant is facing random direction,*/
$.=1;  $.0=4;  $.2=2;  $.3=3;  $.4=4   /*1≡north  2≡east  3≡south 4≡west*/
/*───────────────────────────────────────────ant walks hither & thither.*/
  do steps=1  until x<Lb | x>Rb | y<Bb | y>Tb /*walk until out─of─bounds*/
  black=@.x.y;      @.x.y= \ @.x.y     /*ant's cell color code; flip it.*/
  if black  then dir=dir-1             /*if cell was black,  turn  left.*/
            else dir=dir+1             /* "   "   "  white,  turn right.*/
  dir=$.dir                            /*possibly adjust for under/over.*/
      select                           /*ant walks direction it's facing*/
      when dir==1  then y= y + 1       /*walking north?  Then go "up".  */
      when dir==2  then x= x + 1       /*   "     east?    "  "  "right"*/
      when dir==3  then y= y - 1       /*   "    south?    "  "  "down".*/
      when dir==4  then x= x - 1       /*   "     west?    "  "  "left".*/
      end   /*select*/
  end       /*steps*/
/*───────────────────────────────────────────the ant is finished walking*/
say center(" Langton's ant walked"   steps   'steps. ', 79, "─");      say
                                       /* [↓] show Langton's ant's trail*/
    do minx =Lb  to Rb                 /*find leftmost non─blank column.*/
        do y=Bb  to Tb                 /*search row by row for the min. */
        if @.minx.y  then leave minx   /*found one, now quit searching. */
        end   /*y*/
    end       /*minx*/                 /*above code crops left of array.*/

  do y=Tb  to Bb  by -1;  _=           /*display a plane (row) of cells.*/
     do x=minx  to Rb;    _=_ || @.x.y /*build a cell row for display.  */
     end   /*x*/
  _=strip(translate(_,char,10), 'T')   /*color the cells: black | white.*/
  if _\==''  then say _                /*say line, strip trailing blanks*/
  end      /*y*/                       /*stick a fork in it, we're done.*/
