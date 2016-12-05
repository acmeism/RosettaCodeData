/*REXX program solves a  Numbrix (R) puzzle, it also displays the puzzle and solution.  */
maxR=0;    maxC=0;    maxX=0;     minR=9e9;      minC=9e9;    minX=9e9;    cells=0;    @.=
parse arg xxx;        PZ='Numbrix puzzle'        /*get the cell definitions from the CL.*/
xxx=translate(xxx, , "/\;:_", ',')               /*also allow other characters as comma.*/

               do  while xxx\='';  parse var  xxx    r c   marks  ','  xxx
                   do  while marks\='';          _=@.r.c
                   parse var marks  x  marks
                   if datatype(x,'N')   then x=abs(x)/1               /*normalize  │x│  */
                   minR=min(minR,r);  maxR=max(maxR,r); minC=min(minC,c); maxC=max(maxC,c)
                   if x==1   then do;  !r=r;  !c=c;  end              /*the START cell. */
                   if _\=='' then call err "cell at" r c 'is already occupied with:'  _
                   @.r.c=x;   c=c+1;    cells=cells+1                 /*assign a mark.  */
                   if x==.              then iterate                  /*is a hole?  Skip*/
                   if \datatype(x,'W')  then call err 'illegal marker specified:' x
                   minX=min(minX,x);    maxX=max(maxX,x)              /*min and max  X. */
                   end   /*while marks¬='' */
               end       /*while xxx  ¬='' */
call show                                        /* [↓]  is used for making fast moves. */
Nr = '0  1   0  -1    -1   1   1  -1'            /*possible  row     for the next move. */
Nc = '1  0  -1   0     1  -1   1  -1'            /*   "      column   "   "    "    "   */
pMoves=words(Nr) -4*(left(PZ,1)=='N')            /*is this to be a Numbrix puzzle ?     */
  do i=1  for pMoves;   Nr.i=word(Nr,i);   Nc.i=word(Nc,i);   end     /*for fast moves. */
if \next(2,!r,!c)  then call err 'No solution possible for this' PZ"."
say;  say 'A solution for the'   PZ   "exists.";    say;                call show
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:  say;    say '***error*** (from' PZ"): "    arg(1);        say;          exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
next: procedure expose @. Nr. Nc. cells pMoves;  parse arg #,r,c;   ##=#+1
           do t=1  for pMoves                                   /* [↓]  try some moves. */
           parse value  r+Nr.t c+Nc.t  with nr nc               /*next move coördinates.*/
           if @.nr.nc==.  then do;                @.nr.nc=#     /*let's try this move.  */
                               if #==cells        then return 1 /*is this the last move?*/
                               if next(##,nr,nc)  then return 1
                               @.nr.nc=.                        /*undo the above move.  */
                               iterate                          /*go & try another move.*/
                               end
           if @.nr.nc==#  then do                               /*this a fill-in move ? */
                               if #==cells        then return 1 /*this is the last move.*/
                               if next(##,nr,nc)  then return 1 /*a fill-in move.       */
                               end
           end   /*t*/
      return 0                                                  /*this ain't working.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: if maxR<1 | maxC<1  then call err  'no legal cell was specified.'
      if minX<1           then call err  'no  1  was specified for the puzzle start'
      w=max(2,length(cells));  do    r=maxR  to minR  by -1; _=
                                  do c=minC  to maxC;        _=_ right(@.r.c,w); end /*c*/
                               say _
                               end   /*r*/
      say;    return
