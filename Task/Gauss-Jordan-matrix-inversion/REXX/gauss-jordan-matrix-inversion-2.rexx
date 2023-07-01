/*REXX program performs a  (square)  matrix inversion  using the  Gauss─Jordan  method. */
data=  8 3 7 5 9 12 10 11 6 2 4 13 14 15 16 17   /*the matrix element values.           */
call build  4                                    /*assign data elements to the matrix.  */
call show '@', 'The matrix of order '  n  " is:" /*display the (square) matrix.         */
call aux                                         /*define the auxiliary (identity) array*/
call invert                                      /*invert the matrix, store result in X.*/
call show 'X', "The inverted matrix is:"         /*display (inverted) auxiliary matrix. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
aux:   x.= 0;                do i=1  for n;   x.i.i= 1;   end;        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
build: arg n;  #=0;  w=0;    do    r=1  for n                /*read a row of the matrix.*/
                                do c=1  for n;  #= # + 1     /*  "  " col  "  "     "   */
                                @.r.c= word(data, #);  w= max(w, length(@.r.c) )
                                end   /*c*/                  /*W:  max width of a number*/
                             end      /*r*/;    return
/*──────────────────────────────────────────────────────────────────────────────────────*/
invert: do k=1  for n;                      t= @.k.k   /*divide each matrix row by  T.  */
              do c=1  for n; @.k.c= @.k.c / t          /*process row of original matrix.*/
                             x.k.c= x.k.c / t          /*   "     "   " auxiliary   "   */
              end   /*c*/
           do r=1  for n;    if r==k  then iterate     /*skip if R is the same row as K.*/
           t= @.r.k
              do c=1  for n; @.r.c= @.r.c - t*@.k.c    /*process row of original matrix.*/
                             x.r.c= x.r.c - t*x.k.c    /*   "     "   " auxiliary    "  */
              end   /*c*/
           end      /*r*/
        end         /*k*/;                      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: parse arg ?, title;  say;  say title;  f= 4     /*F:  fractional digits precision.*/
        do   r=1  for n; _=
          do c=1  for n; if ?=='@' then _= _ right(       @.r.c, w)
                                   else _= _ right(format(x.r.c, w, f), w + f + length(.))
          end   /*c*/;   say _
        end     /*r*/;                          return
