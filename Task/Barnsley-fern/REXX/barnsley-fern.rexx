/*REXX pgm gens X & Y coördinates for a scatter plot to be used to show a Barnsley fern.*/
parse arg N FID seed .                           /*obtain optional arguments from the CL*/
if   N=='' |   N==","  then   N= 100000          /*Not specified?   Then use the default*/
if FID=='' | FID==","  then FID= 'BARNSLEY.DAT'  /* "      "          "   "   "     "   */
if datatype(seed,'W')  then call random ,,seed   /*if specified, then use random seed.  */
call lineout FID, , 1                            /*just set the file ptr to the 1st line*/
x=0                                              /*set the initial value for  X  coörd. */
y=0                                              /* "   "     "      "    "   Y    "    */
    do #=1  for N                                /*generate   N   number of plot points.*/
    ?=random(, 100)                              /*generate a random number: 0 ≤ ? ≤ 100*/
       select
       when ?==0  then do;   xx=   0           ;    yy=            .16*y         ;     end
       when ?< 8  then do;   xx=  .2 *x - .26*y;    yy=  .23*x  +  .22*y  +  1.6 ;     end
       when ?<15  then do;   xx= -.15*x + .28*y;    yy=  .26*x  +  .24*y  +   .44;     end
       otherwise             xx=  .85*x + .04*y;    yy= -.04*x  +  .85*y  +  1.6
       end   /*select*/
                             x=xx;                     y=yy
    if #==1  then  do;    minx= x;  maxx= x;        miny= y;  maxy= y
                   end
                          minx= min(minx, x);       miny= min(miny, y)
                          maxx= max(maxx, x);       maxy= max(maxy, y)
    call lineout FID, x","y
    end      /*#*/                               /* [↓]  close the file (safe practice).*/
call lineout FID                                 /*stick a fork in it,  we're all done. */
