/*REXX program  generates and displays  a (rectangular)  solvable maze. */
height=0;    @.=0                      /*default for all cells  visited.*/
parse arg rows cols seed .             /*allow user to specify maze size*/
if rows='' | rows==','  then rows=19   /*No rows given?  Use the default*/
if cols='' | cols==','  then cols=19   /*No cols given?  Use the default*/
if seed\=='' then call random ,,seed   /*use a seed for repeatability.  */
call buildRow '┌'copies('─┬',cols-1)'─┐'   /*build the top edge of maze.*/
                                       /*(below)  build the maze's grid.*/
  do    r=1  for rows;  _=;     __=;          hp= '|';    hj='├'
     do c=1  for cols;  _= _||hp'1';     __=__||hj'─';    hj='┼';   hp='│'
     end   /*c*/
                    call buildRow  _'│'    /*build  right edge of cells.*/
  if r\==rows  then call buildRow __'┤'    /*  "      "     "   "  maze.*/
  end      /*r*/

call buildRow '└'copies('─┴',cols-1)'─┘'   /*build the bottom maze edge.*/
r!=random(1,rows)*2;   c!=random(1,cols)*2; @.r!.c!=0  /*choose 1st cell*/
                                       /* [↓]  traipse through the maze.*/
  do forever;    n=hood(r!,c!);     if n==0  then  if \fcell()  then leave
  call ?;        @._r._c=0             /*get the (next) direction to go.*/
  ro=r!; co=c!;  r!=_r;   c!=_c        /*save original cell coordinates.*/
  ?.zr=?.zr%2;   ?.zc=?.zc%2           /*get the row and cell directions*/
  rw=ro+?.zr;    cw=co+?.zc            /*calculate the next row and col.*/
  @.rw.cw='·'                          /*mark the cell as being visited.*/
  end   /*forever*/

         do     r=1  for height;       _=           /*display the maze. */
             do c=1  for cols*2 + 1;   _=_ || @.r.c;   end  /*c*/
         if \(r//2)  then _=translate(_, '\', "·")  /*trans to backslash*/
         _=changestr(1,_,111)          /*these four ────────────────────*/
         _=changestr(0,_,000)          /*─── statements are ────────────*/
         _=changestr('·',_,"   ")      /*──────── used for preserving ──*/
         _=changestr('─',_,"───")      /*──────────── the aspect ratio. */
         say translate(_,'│',"|\10")   /*make it presentable for screen.*/
         end   /*r*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────@ subroutine────────────────────────*/
@: parse arg _r,_c;    return @._r._c  /*a fast way to reference a cell.*/
/*──────────────────────────────────? subroutine────────────────────────*/
?: do forever;  ?.=0;  ?=random(1,4);  if ?==1  then ?.zc=-2     /*north*/
                                       if ?==2  then ?.zr=+2     /* east*/
                                       if ?==3  then ?.zc=+2     /*south*/
                                       if ?==4  then ?.zr=-2     /* west*/
     _r=r!+?.zr;   _c=c!+?.zc;   if @._r._c==1  then return
     end   /*forever*/
/*──────────────────────────────────BUILDROW subroutine─────────────────*/
buildRow:  parse arg z;    height=height+1;    width=length(z)
           do c=1  for width;   @.height.c=substr(z,c,1);   end;    return
/*──────────────────────────────────FCELL subroutine────────────────────*/
fcell: do   r=1  for rows;  r2=r+r
         do c=1  for cols;  c2=c+c
         if hood(r2,c2)==1  then do; r!=r2; c!=c2; @.r!.c!=0; return 1;end
         end   /*c*/
       end     /*r*/
return 0
/*──────────────────────────────────HOOD subroutine─────────────────────*/
hood: parse arg rh,ch;  return @(rh+2,ch)+@(rh-2,ch)+@(rh,ch-2)+@(rh,ch+2)
