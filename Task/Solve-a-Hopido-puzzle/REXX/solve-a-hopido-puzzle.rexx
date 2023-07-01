/*REXX program solves a Hopido puzzle,  it also displays the puzzle  and  the solution. */
call time 'Reset'                                /*reset the REXX elapsed timer to zero.*/
maxR=0;    maxC=0;    maxX=0;     minR=9e9;      minC=9e9;    minX=9e9;    cells=0;    @.=
parse arg xxx                                    /*get the cell definitions from the CL.*/
xxx=translate(xxx, , "/\;:_", ',')               /*also allow other characters as comma.*/

               do  while xxx\='';       parse var  xxx    r  c  marks  ','  xxx
                   do  while marks\='';               _=@.r.c
                   parse var  marks  x  marks
                   if datatype(x,'N')   then  x=x/1                   /*normalize   X.  */
                   minR=min(minR,r); maxR=max(maxR,r);  minC=min(minC,c); maxC=max(maxC,c)
                   if x==1   then do;  !r=r;  !c=c;  end              /*the START cell. */
                   if _\=='' then call err "cell at"  r  c  'is already occupied with:' _
                   @.r.c=x;   c=c+1;    cells=cells+1                 /*assign a mark.  */
                   if x==.              then iterate                  /*is a hole?  Skip*/
                   if \datatype(x,'W')  then call err 'illegal marker specified:' x
                   minX=min(minX,x);    maxX=max(maxX,x)              /*min and max  X. */
                   end   /*while marks¬='' */
               end       /*while xxx  ¬='' */
call show                                        /* [↓]  is used for making fast moves. */
Nr = '0  3   0  -3    -2   2   2  -2'            /*possible  row     for the next move. */
Nc = '3  0  -3   0     2  -2   2  -2'            /*   "      column   "   "    "    "   */
pMoves=words(Nr)                                 /*the number of possible moves.  */
                   do i=1  for pMoves;   Nr.i=word(Nr, i);   Nc.i=word(Nc,i);   end  /*i*/
if \next(2,!r,!c)  then call err  'No solution possible for this Hopido puzzle.'
say 'A solution for the Hopido exists.';      say;               call show
etime= format(time('Elapsed'), , 2)              /*obtain the elapsed time (in seconds).*/
if etime<.1  then say 'and took less than  1/10  of a second.'
             else say 'and took'       etime         "seconds."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:  say;      say '***error*** (from Hopido): '  arg(1);          say;           exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
next: procedure expose @. Nr. Nc. cells pMoves;  parse arg #,r,c;   ##=#+1
           do t=1  for pMoves                                   /* [↓]  try some moves. */
           parse value  r+Nr.t c+Nc.t  with nr nc  /*next move coördinates*/
           if @.nr.nc==.  then do;                @.nr.nc=#     /*let's try this move.  */
                               if #==cells        then leave    /*is this the last move?*/
                               if next(##,nr,nc)  then return 1
                               @.nr.nc=.                        /*undo the above move.  */
                               iterate                          /*go & try another move.*/
                               end
           if @.nr.nc==#  then do                               /*this a fill-in move ? */
                               if #==cells        then return 1 /*this is the last move.*/
                               if next(##,nr,nc)  then return 1 /*a fill-in move.       */
                               end
           end   /*t*/
return 0                                                        /*This ain't working.   */
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: if maxR<1 | maxC<1  then call err  'no legal cell was specified.'
      if minX<1           then call err  'no  1  was specified for the puzzle start'
      w=max(2,length(cells));  do    r=maxR  to minR  by -1; _=
                                  do c=minC  to maxC;        _=_ right(@.r.c,w); end /*c*/
                               say _
                               end   /*r*/
      say;    return
