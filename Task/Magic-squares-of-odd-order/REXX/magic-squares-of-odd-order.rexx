/*REXX program generates and displays  true magic squares  (for odd N). */
parse arg N .;   if N==''  then N=5    /*matrix size ¬given? Use default*/
w=length(N*N);   r=2;      c=(n+1)%2-1 /*define initial row and column. */
@.=.                                   /* [↓]   uses the Siamese method.*/
    do j=1  for n*n;   br=r==N & c==N; r=r-1;  c=c+1   /*BR=bottom right*/
    if r<1 & c>N then do;  r=r+2;  c=c-1;    end       /*R under, C over*/
    if r<1       then r=n; if r>n  then r=1; if c>n then c=1  /*overflow*/
    if @.r.c\==. then do; r=r+2; c=c-1; if br then do; r=N; c=c+1; end;end
    @.r.c=j                            /*assign #───►square matrix cell.*/
    end   /*j*/                        /* [↑]  can handle even N matrix.*/
                                       /* [↓]  displays (aligned) matrix*/
       do   r=1  for N;  _=            /*display 1 matrix row at a time.*/
         do c=1  for N;  _=_ right(@.r.c, w);  end  /*c*/    /*build row*/
       say substr(_,2)                 /*row has an extra leading blank.*/
       end   /*c*/                     /* [↑]   also right-justified #s.*/
say                                    /*might as well show a blank line*/
if N//2  then say 'The magic number  (or magic constant is): ' N*(n*n+1)%2
                                       /*stick a fork in it, we're done.*/
