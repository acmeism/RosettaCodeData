/*REXX program creates a  matrix  from console input, performs/shows  LU  decomposition.*/
#=0;     P.=0;     PA.=0;      L.=0;      U.=0   /*initialize some variables to zero.   */
parse arg x                                      /*obtain matrix elements from the C.L. */
call makeMat                                     /*make the  A  matrix from the numbers.*/
call showMat 'A',  N                             /*display the   A   matrix.            */
call manPmat                                     /*manufacture   P  (permutation).      */
call showMat 'P',  N                             /*display the   P   matrix.            */
call multMat                                     /*multiply the  A and P matrices.      */
call showMat 'PA', N                             /*display the   PA  matrix.            */
       do y=1 for N;  call manUmat y             /*manufacture   U   matrix, parts.     */
                      call manLmat y             /*manufacture   L   matrix, parts.     */
       end
call showMat 'L',  N                             /*display the   L   matrix.            */
call showMat 'U',  N                             /*display the   U   matrix.            */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:  say;    say '***error!***';    say;    say arg(1);    say;    exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
makeMat: ?=words(x);    do N=1 for ?;  if N**2==?  then leave;  end  /*N*/
         if N**2\==?  then call er 'not correct number of elements entered: ' ?

                        do     r=1  for N        /*build the  "A"  matrix from the input*/
                            do c=1  for N;    #=#+1;    _=word(x,#);    A.r.c=_
                            if \datatype(_,'N')  then call er "element isn't numeric: "  _
                            end   /*c*/
                        end       /*r*/
         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
manLmat: parse arg ?                                   /*manufacture  L  (lower) matrix.*/
                        do     r=1  for N
                            do c=1  for N;  if r==c  then do;    L.r.c=1;   iterate;   end
                            if c\==? | r==c | c>r    then iterate
                            _=PA.r.c
                                            do k=1  for c-1;  _=_-U.k.c*L.r.k;  end  /*k*/
                            L.r.c=_/U.c.c
                            end   /*c*/
                        end       /*r*/
         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
manPmat: c=N;           do r=N  by -1  for N           /*manufacture  P  (permutation). */
                        P.r.c=1;   c=c+1;   if c>N  then c=N%2;   if c==N  then c=1
                        end   /*r*/
         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
manUmat: parse arg ?                                   /*manufacture  U  (upper) matrix.*/
                        do    r=1  for N;   if r\==?  then iterate
                           do c=1  for N;   if c<r    then iterate
                           _=PA.r.c
                                            do k=1  for r-1;  _=_-U.k.c*L.r.k;  end  /*k*/
                           U.r.c=_/1
                           end   /*c*/
                        end      /*r*/
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
multMat:                do      i=1  for N           /*multiply matrix  P & A  ──► PA */
                           do   j=1  for N
                             do k=1  for N;  pa.i.j=(pa.i.j   +   p.i.k * a.k.j) / 1
                             end   /*k*/
                             end   /*j*/
                        end        /*i*/
        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: parse arg mat,rows,cols;    w=0;    cols=word(cols rows,1);    say
                        do    r=1  for rows
                           do c=1  for cols;  w=max(w, length( value( mat'.'r"."c ) ) )
                           end  /*c*/
                        end     /*r*/
         say center(mat 'matrix',cols*(w+1)+7,"─")
                        do    r=1  for rows;  _=
                           do c=1  for cols;  _=_ right(value(mat'.'r'.'c),w+1); end /*c*/
                        say _
                        end     /*r*/
         return
