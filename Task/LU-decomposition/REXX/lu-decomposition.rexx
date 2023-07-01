/*REXX program creates a  matrix  from console input, performs/shows  LU  decomposition.*/
#= 0;    P.= 0;    PA.= 0;     L.= 0;     U.= 0  /*initialize some variables to zero.   */
parse arg x                                      /*obtain matrix elements from the C.L. */
                  call bldAMat;       call showMat 'A'    /*build and display A  matrix.*/
                  call bldPmat;       call showMat 'P'    /*  "    "     "    P     "   */
                  call multMat;       call showMat 'PA'   /*  "    "     "    PA    "   */
  do y=1  for N;  call bldUmat;       call bldLmat        /*build     U  and  L     "   */
  end   /*y*/
                  call showMat 'L';   call showMat 'U'    /*display   L  and  U     "   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bldAMat: ?= words(x);  do N=1  for ?  until N**2>=?                /*find matrix size.  */
                       end  /*N*/
         if N**2\==?  then do;  say '***error*** wrong # of elements entered:'  ?;  exit 9
                           end
                  do    r=1  for N                                 /*build   A   matrix.*/
                     do c=1  for N;        #= # + 1;     _= word(x, #);        A.r.c= _
                     if \datatype(_, 'N')  then call er "element isn't numeric: "  _
                     end   /*c*/
                  end      /*r*/;          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bldLmat:          do    r=1  for N                                 /*build lower matrix.*/
                     do c=1  for N;        if r==c  then do;   L.r.c= 1;   iterate;    end
                     if c\==y | r==c | c>r  then iterate
                     _= PA.r.c
                                           do k=1  for c-1;    _= _   -   U.k.c * L.r.k
                                           end  /*k*/
                     L.r.c= _ / U.c.c
                     end   /*c*/
                  end      /*r*/;          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bldPmat: c= N;    do r=N  by -1  for N;    P.r.c= 1;     c= c + 1  /*build perm. matrix.*/
                  if c>N  then c= N%2;     if c==N  then c= 1
                  end   /*r*/;             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bldUmat:          do    r=1  for N;        if r\==y  then iterate  /*build upper matrix.*/
                     do c=1  for N;        if c<r    then iterate
                     _= PA.r.c
                                           do k=1  for r-1;     _= _   -   U.k.c * L.r.k
                                           end   /*k*/
                     U.r.c= _ / 1
                     end   /*c*/
                  end      /*r*/;          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
multMat:          do      i=1  for N                 /*multiply matrix  P and A  ──► PA */
                     do   j=1  for N
                       do k=1  for N;      pa.i.j=  (pa.i.j   +   p.i.k * a.k.j)    /    1
                       end   /*k*/
                     end     /*j*/                   /*÷ by one does normalization [↑]. */
                  end        /*i*/;        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: parse arg mat,rows,cols;   say;   rows= word(rows N,1);   cols= word(cols rows,1)
         w= 0;    do    r=1  for rows
                     do c=1  for cols;     w= max(w,  length( value( mat'.'r"."c ) ) )
                     end  /*c*/
                  end     /*r*/
         say center(mat  'matrix',  cols * (w + 1) + 7,  "─")      /*display the header.*/
                  do    r=1  for rows;     _=
                     do c=1  for cols;     _= _ right( value(mat'.'r"."c),   w + 1)
                     end   /*c*/
                  say _
                  end      /*r*/;       return
