/*REXX program implements Langton's ant and displays the path it walked.*/
parse arg dir .                        /*allow specification: ant facing*/
                                       /*binary colors: 0=white, 1=black*/
@.=0                                   /*define stem array  (all white).*/
lb=1        ;  rb=100                  /* right boundry,  right boundry.*/
bb=1        ;  tb=100                  /*bottom    "        top    "    */
x=(rb-lb)%2 ;  y=(tb-bb)%2             /*approximate center (walk start)*/
if dir==''     then dir=random(1,4)    /*ant is facing random direction,*/
                                       /*1=north  2=east  3=south 4=west*/
/*───────────────────────────────────────────ant walks hither & thither.*/
  do steps=1 until x<lb | x>rb | y<bb | y>tb  /*walk until out-of-bounds*/
  black=@.x.y                          /*get color code of ant's cell.  */
  @.x.y=\@.x.y                         /*"flip" the color of the cell.  */
  if black   then dir=dir-1            /*if cell was black, turn  left. */
             else dir=dir+1            /* "   "   "  white,   "  right. */
  if dir==0  then dir=4                /*ant should be facing  "west".  */
  if dir==5  then dir=1                /* "     "    "    "    "north". */
       select                          /*ant walks direction it's facing*/
       when dir==1  then y=y+1         /*walking north?  Then go "up".  */
       when dir==2  then x=x+1         /*   "     east?    "  "  "right"*/
       when dir==3  then y=y-1         /*   "    south?    "  "  "down".*/
       when dir==4  then x=x-1         /*   "     west?    "  "  "left".*/
       end   /*select*/
  end        /*steps*/
/*───────────────────────────────────────────the ant is finished walking*/
say center(" Langton's ant walked" steps 'steps. ',79,"─");    say
                                       /*Display Langton's ant's trail. */
  do minx =lb  to rb                   /*find leftmost non-blank column.*/
      do y=bb  to tb                   /*search row by row for it.      */
      if @.minx.y  then leave minx     /*found one, now quit searching. */
      end   /*y*/
  end       /*minx*/                   /*above code crops left of array.*/

  do y=tb  to bb  by -1;    _=''       /*display a plane (row) of cells.*/
      do x=minx  to rb                 /*process a "row" of cells.      */
      _=_ || @.x.y                     /*build a cell row for display.  */
      end   /*x*/
  _=translate(_,'#',10)                /*color the cells: black | white.*/
  if _\='' then say strip(_,'T')       /*say line, strip trailing blanks*/
  end       /*y*/
                                       /*stick a fork in it, we're done.*/
