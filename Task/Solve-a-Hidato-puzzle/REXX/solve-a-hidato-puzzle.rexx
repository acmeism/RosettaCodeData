/*REXX pgm solves a Hidato or Numbrix puzzle, displays puzzle & solution*/
maxr=0;  maxc=0;  maxx=0;  minr=9e9;  minc=9e9;  minx=9e9;  cells=0;  @.=
parse arg xxx;    PZ='Hidato puzzle'   /*get cell definitions from C.L. */
               do  while xxx\='';  parse var  xxx    r  c  marks  ','  xxx
                   do  while marks\='';                    _=@.r.c
                   parse var marks  x marks
                   if datatype(x,'N')  then do;  x=x/1     /*normalize X*/
                                            if x<0  then PZ='Numbrix puzzle'
                                            x=abs(x)       /*use  │x│   */
                                            end
                   minr=min(minr,r);    maxr=max(maxr,r)
                   minc=min(minc,c);    maxc=max(maxc,c)
                   if x==1   then do;  !r=r;  !c=c;  end   /*start cell.*/
                   if _\=='' then call err "cell at" r c 'is already occupied with:' _
                   @.r.c=x;   c=c+1;    cells=cells+1      /*assign mark*/
                   if x==.              then iterate       /*hole? Skip.*/
                   if \datatype(x,'W')  then call err 'illegal marker specified:' x
                   minx=min(minx,x);    maxx=max(maxx,x)   /*min & max X*/
                   end   /*while marks¬='' */
               end       /*while xxx  ¬='' */
call showGrid                          /* [↓] used for making fast moves*/
Nr = '0  1   0  -1    -1   1   1  -1'  /*possible row for the next move.*/
Nc = '1  0  -1   0     1  -1   1  -1'  /*   "     col  "   "    "    "  */
pMoves=words(Nr) -4*(left(PZ,1)=='N')  /*is this to be a Numbrix puzzle?*/
  do i=1  for pMoves; Nr.i=word(Nr,i); Nc.i=word(Nc,i); end /*fast moves*/
if \next(2,!r,!c)  then call err 'No solution possible.'
say;     say 'A solution for the' PZ "exists.";    say;      call showGrid
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ERR subroutine──────────────────────*/
err:  say;    say '***error!*** (from' PZ"): "  arg(1);    say;    exit 13
/*──────────────────────────────────NEXT subroutine─────────────────────*/
next: procedure expose @. Nr. Nc. cells pMoves;  parse arg #,r,c;   ##=#+1
         do t=1  for pMoves                      /* [↓]  try some moves.*/
         parse value  r+Nr.t c+Nc.t  with nr nc  /*next move coördinates*/
         if @.nr.nc==.  then do;                 @.nr.nc=#     /*a move.*/
                             if #==cells         then leave    /*last 1?*/
                             if next(##,nr,nc)   then return 1
                             @.nr.nc=.           /*undo the above move. */
                             iterate             /*go & try another move*/
                             end
         if @.nr.nc==#  then do                  /*is this a fill-in ?  */
                             if #==cells         then return 1 /*last 1.*/
                             if next(##,nr,nc)   then return 1 /*fill-in*/
                             end
         end   /*t*/
return 0                                         /*This ain't working.  */
/*──────────────────────────────────SHOWGRID subroutine─────────────────*/
showGrid: if maxr<1 | maxc<1  then call err 'no legal cell was specified.'
if minx<1        then call err 'no  1  was specified for the puzzle start'
if maxx\==cells  then call err 'no' cells "was specified for the puzzle end"
w=length(maxx);   do r=maxr  to minr  by -1;  _=
                      do c=minc  to maxc;  _=_ right(@.r.c,w);  end  /*c*/
                  say _
                  end   /*r*/
return
