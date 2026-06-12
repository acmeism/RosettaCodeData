/*REXX program solves the    A*   search problem   for a  (general)   NxN   grid.       */
parse arg  N  sCol sRow .                        /*obtain optional arguments from the CL*/
if    N=='' |    N==","  then    N=8             /*No grid size specified?  Use default.*/
if sCol=='' | sCol==","  then sCol=1             /*No starting column given?  "    "    */
if sRow=='' | sRow==","  then sRow=1             /* "     "     row     "     "    "    */
beg= '─0─'                                       /*mark the start of the journey in grid*/
o.=.;         p.=0                               /*list of optimum start journey starts.*/
times=0                                          /*cntr/pos for number of optimizations.*/
              Pc = ' 1  1  0  0   1 -1 -1 -1 '   /*the possible column moves for a path.*/
              Pr = ' 1  0  1 -1  -1  0  1 -1 '   /* "      "     row     "    "  "   "  */
Pcm=words(Pc)                                    /* [↑]  optimized for moving right&down*/
$.=1e6;  OK=0;     min$=$.                       /*# possible directions; cost; solution*/
@Aa= " A*  search algorithm on"                  /*a handy─dandy literal for the  SAYs. */
flasher= '@. $. min$ N o. p. Pc. Pcm Pr. sCol sRow times'   /*a literal list for EXPOSE.*/
call path 0                                      /*find a possible solution for the grid*/
@NxN= 'a '      N"x"N      ' grid'               /*a literal used for a  SAY  statement.*/
if OK  then say 'A solution for the'    @Aa     @NxN       "with a score of "     @.N.N':'
       else say 'No'   @Aa   "solution for"     @NxN'.'
call show 1                                      /*invoke subroutine to display the grid*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:    parse arg x,y,aChar;   if arg()==3  then @.x.y=aChar;                   return @.x.y
@p:   parse arg x,y;         if datatype(@.x.y, 'W')  then return @.x.y<m-1;  return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
barr: $=2.4 2.5 2.6 3.6 4.6 5.6 5.5 5.4 5.3 5.2 4.2 3.2  /*locations of barriers on grid*/
         do b=1  for words($);    _=word($, b);   parse var _ c '.' r;  call @ c+1,r+1,"█"
         end   /*b*/;             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
move: procedure expose (flasher);          parse arg m,col,row   /*obtain  move,col,row.*/
         do t=1  for Pcm;         nc=col + Pc.t;   nr=row + Pr.t /*a new path position. */
         if @.nc.nr==.  then do;  if opti()  then iterate        /*Costlier path?  Next.*/
                                  @.nc.nr=m;       p.1.m=nc nr   /*Empty?  A legal path.*/
                                  p.pcm.m=nr nc-1                /*used for a fast path.*/
                                  if nc==N  then if nr==N  then return 1   /*last move? */
                                  if move(m + 1,  nc, nr)  then return 1   /*  "    "   */
                                  @.nc.nr=.                      /*undo the above move. */
                             end                                 /*try a different move.*/
         end   /*t*/                                             /* [↑]  all moves tried*/
      return 0                                                   /*path isn't possible. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
opti: ncm=nc-1;   nrm=nr-1;       if @p(ncm, nrm)  then return 1
                                  if @p(ncm, nr )  then return 1
                                  if @p(nc,  nrm)  then return 1
      ncp=nc+1;   nrp=nr+1;       if @p(ncp, nr )  then return 1
                                  if @p(ncp, nrm)  then return 1
                                  if @p(nc,  nrp)  then return 1
                                  if @p(ncm, nrp)  then return 1
                                  if @p(ncp, nrp)  then return 1;         return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
path: parse arg z;                t=times        /*initial move can only be one of eight*/
        do #=1  for Pcm;          @.=            /*optimize for each degree of movement.*/
        if z\==0  then  if #\==z  then iterate   /*This a particular low─cost request ? */
             do c=1  for  N;    do r=1  for N;   @.c.r=.;   end  /*r*/
             end   /*c*/
        iCol=sCol;  iRow=sRow;  @.sCol.sRow= beg /*all path's initial starting  position*/
        call barr                                /*place the barriers on the grid.      */
        Pco=subword(Pc Pc, #, Pcm);  Pro=subword(Pr Pr, #, Pcm)
        parse var  Pco   Pc.1 Pc.2 Pc.3 Pc.4 Pc.5 Pc.6 Pc.7 Pc.8  /*possible directions.*/
        parse var  Pro   Pr.1 Pr.2 Pr.3 Pr.4 Pr.5 Pr.6 Pr.7 Pr.8  /*    "         "     */
             do o=1  for times;  parse var o.o c r;    @.c.r=o;     iRow=r;     iCol=c
             end   /*o*/
        fp=move(1+times, iCol, iRow);      sol=@N.N\==. & fp
        if sol  then do;    $.#=@.N.N            /*Found a solution?  Remember the cost.*/
                     OK=1;  min$=min(min$, $.#)
                     end
        end   /*#*/
      wp=1e7; wg=0;  do g=1  for Pcm; if $.g<wp & $.g>0 & t\=2  then do; wg=g; wp=$.g; end
                     end   /*g*/                 /* [↑]  find minimum non-zero path cost*/
      if wg==0  then wg=8                        /*Not found?  Then use last cost found.*/
      times=times + 1                            /*bump # times a marker has been placed*/
      o.times= p.wg.times                        /*remember this move location for PATH.*/
      if times<4  then call path 0               /*only do memoization for first 3 moves*/
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: ind=left('', 9 * (n<18) );      say        /*the indentation of the displayed grid*/
      _=substr(copies("┼───", N),2);  say ind translate('┌'_"┐", '┬', "┼")   /*grid top.*/
                                                 /* [↓]  build a display for the grid.  */
       do   c=1  for N;          if c\==1 & arg(1)  then say  ind  '├'_"┤";     L=@.
         do r=1  for N; ?=@.c.r; if c ==N & r==N & ?\==.  then ?='end'; L=L"│"center(?, 3)
         end   /*r*/                             /*done with   rank   of the grid.      */
       say ind translate(L'│', , .)              /*display a     "     "  "    "        */
       end     /*c*/                             /*a 19x19 grid can be shown 80 columns.*/
     say ind translate('└'_"┘",'┴',"┼");  return /*display the very bottom of the grid. */
