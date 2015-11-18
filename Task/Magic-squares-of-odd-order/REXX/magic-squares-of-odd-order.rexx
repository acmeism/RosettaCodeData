/*REXX pgm generates & displays magic squares (odd N will be a true magic sq.)*/
parse arg N .                          /*obtain the optional argument from CL.*/
if N=='' | N==','  then N=5            /*Not specified?  Then use the default.*/
NN=N*N;    w=length(NN)                /*W:  width of largest number (output).*/
r=1;       c=(n+1) % 2                 /*define the initial  row  and  column.*/
@.=.                                   /*assign a default value for entire  @.*/
    do j=1  for N*N                    /* [↓]  filling uses the Siamese method*/
    if r<1 & c>N then do; r=r+2; c=c-1; end   /*row is under,  col is over ···*/
    if r<1       then r=N                     /*row is under,  make row=last. */
    if r>N       then r=1                     /*row is  over,  make row=first.*/
    if c>N       then c=1                     /*col is  over,  make col=first.*/
    if @.r.c\==. then do; r=min(N,r+2); c=max(1,c-1); end  /*at previous cell?*/
    @.r.c=j;              r=r-1; c=c+1 /*assign # ───► cell; next row and col.*/
    end   /*j*/
                                       /* [↓]  display square with aligned #'s*/
       do   r=1  for N;  _=            /*display  one matrix row  at a time.  */
         do c=1  for N;  _=_ right(@.r.c, w);  end  /*c*/     /*build a row.  */
       say substr(_,2)                                        /*display a row.*/
       end   /*c*/
say                                    /* [↑]  If an odd square, show magic #.*/
if N//2  then say 'The magic number  (or magic constant is): '    N * (NN+1) % 2
                                       /*stick a fork in it,  we're all done. */
