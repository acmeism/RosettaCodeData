/*REXX program generates and displays a  rectangular  solvable maze  (of any size).     */
parse arg rows cols seed .                       /*allow user to specify the maze size. */
if rows='' | rows==','  then rows= 19            /*No rows given?  Then use the default.*/
if cols='' | cols==','  then cols= 19            /* " cols   "  ?    "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /*use a random  seed for repeatability.*/
ht=0;                        @.=0                /*HT= # rows in grid;  @.: default cell*/
call makeRow  '┌'copies("~┬", cols - 1)'~┐'      /*construct the top edge of the maze.  */
                                                 /* [↓]  construct the maze's grid.     */
      do    r=1  for rows;   _=;     __=;      hp= "|";              hj= '├'
         do c=1  for cols;   _= _ || hp'1';    __= __ || hj"~";      hj= '┼';      hp= "│"
         end   /*c*/
                        call makeRow  _'│'       /*construct the right edge of the cells*/
      if r\==rows  then call makeRow __'┤'       /*    "      "    "     "   "  "  maze.*/
      end      /*r*/                             /* [↑]  construct the maze's grid.     */

call makeRow  '└'copies("~┴",  cols - 1)'~┘'     /*construct the bottom edge of the maze*/
r!= random(1, rows) *2;     c!= random(1, cols) *2;      @.r!.c!= 0   /*choose 1st cell.*/
                                                 /* [↓]  traipse through the maze.      */
  do forever;    n= hood(r!, c!);    if n==0  then if \fCell()  then leave  /*¬freecell?*/
  call ?;        @._r._c= 0                      /*get the (next) maze direction to go. */
  ro= r!;        co= c!;     r!= _r;    c!= _c   /*save original maze cell coordinates. */
  ?.zr= ?.zr % 2;            ?.zc= ?.zc % 2      /*get the maze row and cell directions.*/
  rw= ro + ?.zr;             cw= co + ?.zc       /*calculate the next row and column.   */
  @.rw.cw= .                                     /*mark the maze cell as being visited. */
  end   /*forever*/
                                                 /* [↓]  display maze to the terminal.  */
         do     r=1  for ht;            _=
             do c=1  for cols*2 + 1;    _= _ || @.r.c;    end  /*c*/
         if \(r//2)  then _= translate(_, '\', .)                   /*trans to backslash*/
         @.r= _                                                     /*save the row in @.*/
         end   /*r*/

      do #=1  for ht;           _= @.#           /*display the maze to the terminal.    */
      call makeNice                              /*prettify cell corners and dead─ends. */
      _=  changestr( 1 ,  _   , 111     )        /*──────these four ────────────────────*/
      _=  changestr( 0 ,  _   , 000     )        /*───────── statements are ────────────*/
      _=  changestr( . ,  _   , "   "   )        /*────────────── used for preserving ──*/
      _=  changestr('~',  _   , "───"   )        /*────────────────── the aspect ratio. */
      say translate( _ , '─│' , "═|\10" )        /*make it presentable for the screen.  */
      end   /*#*/
  exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:       parse arg _r,_c;     return  @._r._c    /*a fast way to reference a maze cell. */
makeRow: parse arg z; ht= ht+1;  do c=1  for length(z); @.ht.c=substr(z,c,1);  end; return
hood:    parse arg rh,ch;     return  @(rh+2,ch)  + @(rh-2,ch)  + @(rh,ch-2)  + @(rh,ch+2)
/*──────────────────────────────────────────────────────────────────────────────────────*/
?:         do forever;  ?.= 0;   ?= random(1, 4);     if ?==1  then ?.zc= -2     /*north*/
                                                      if ?==2  then ?.zr=  2     /* east*/
                                                      if ?==3  then ?.zc=  2     /*south*/
                                                      if ?==4  then ?.zr= -2     /* west*/
           _r= r! + ?.zr;       _c= c! + ?.zc;        if @._r._c == 1    then return
           end   /*forever*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
fCell:     do     r=1  for rows;                rr= r + r
               do c=1  for cols;                         cc= c + c
               if hood(rr,cc)==1  then do;  r!= rr;  c!= cc;   @.r!.c!= 0;  return 1;  end
               end   /*c*/                       /* [↑]  r! and c!  are used by invoker.*/
           end       /*r*/;       return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
makeNice: width= length(_);     old= # - 1;     new= # + 1;     old_= @.old;   new_= @.new
          if left(_, 2)=='├.'  then _= translate(_, "|", '├')
          if right(_,2)=='.┤'  then _= translate(_, "|", '┤')

             do  k=1  for  width  while #==1;         z= substr(_, k, 1) /*maze top row.*/
             if z\=='┬'                  then iterate
             if substr(new_, k, 1)=='\'  then _= overlay("═", _, k)
             end   /*k*/

             do  k=1  for  width  while #==ht;        z= substr(_, k, 1) /*maze bot row.*/
             if z\=='┴'                  then iterate
             if substr(old_, k, 1)=='\'  then _= overlay("═", _, k)
             end   /*k*/

             do  k=3  to  width-2  by 2  while #//2;  z= substr(_, k, 1) /*maze mid rows*/
             if z\=='┼'   then iterate
             le= substr(_   , k-1, 1)
             ri= substr(_   , k+1, 1)
             up= substr(old_, k  , 1)
             dw= substr(new_, k  , 1)
                    select
                    when le== .  & ri== .  & up=='│' & dw=="│"  then _= overlay('|', _, k)
                    when le=='~' & ri=="~" & up=='\' & dw=="\"  then _= overlay('═', _, k)
                    when le=='~' & ri=="~" & up=='\' & dw=="│"  then _= overlay('┬', _, k)
                    when le=='~' & ri=="~" & up=='│' & dw=="\"  then _= overlay('┴', _, k)
                    when le=='~' & ri== .  & up=='\' & dw=="\"  then _= overlay('═', _, k)
                    when le== .  & ri=="~" & up=='\' & dw=="\"  then _= overlay('═', _, k)
                    when le== .  & ri== .  & up=='│' & dw=="\"  then _= overlay('|', _, k)
                    when le== .  & ri== .  & up=='\' & dw=="│"  then _= overlay('|', _, k)
                    when le== .  & ri=="~" & up=='\' & dw=="│"  then _= overlay('┌', _, k)
                    when le== .  & ri=="~" & up=='│' & dw=="\"  then _= overlay('└', _, k)
                    when le=='~' & ri== .  & up=='\' & dw=="│"  then _= overlay('┐', _, k)
                    when le=='~' & ri== .  & up=='│' & dw=="\"  then _= overlay('┘', _, k)
                    when le=='~' & ri== .  & up=='│' & dw=="│"  then _= overlay('┤', _, k)
                    when le== .  & ri=="~" & up=='│' & dw=="│"  then _= overlay('├', _, k)
                    otherwise   nop
                    end   /*select*/
             end          /*k*/;                   return
