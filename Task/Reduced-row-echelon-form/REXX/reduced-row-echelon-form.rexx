/*REXX program performs  Reduced Row Echelon Form  (RREF)  on a matrix).      */
cols=0;   w=0;    @.=0                 /*max cols in a row; max width; matrix.*/
mat.=;                                   mat.1=  '    1   2   -1      -4   '
                                         mat.2=  '    2   3   -1     -11   '
                                         mat.3=  '   -2   0   -3      22   '
          do r=1  until mat.r=='';     _=mat.r  /*build  @.row.col from mat.X */
                      do c=1  until _='';             parse  var   _   @.r.c _
                      w=max(w, length(@.r.c))   /*get max width of an element.*/
                      end   /*c*/
          cols=max(cols,c)                      /*remember max number of cols.*/
          end   /*r*/
rows=r-1                               /*adjust the row count (from  DO loop).*/
w=w+1                                  /*bump maximum width for a better view.*/
call showMat  'original matrix'        /*display the original matrix to screen*/
!=1                                    /*set the working column pointer to  1.*/
    /* ┌───────────────────────────────◄── Reduced Row Echelon Form on matrix.*/
  do r=1  for rows  while cols>!       /*begin to perform the heavy lifting.  */
  j=r
      do  while  @.j.!==0;  j=j+1
      if j==rows  then do;  j=r;   !=!+1;   if cols==!  then leave r;   end
      end      /*while*/
                                       /* [↓]  swap rows J,R (but not if same)*/
      do _=1 for cols while j\==r; parse value @.r._ @.j._ with @.j._ @._._; end
  ?=@.r.!
      do d=1 for cols while ?\=1;  @.r.d=@.r.d/?;  end  /*d*/
                                       /* [↑] divide row J by @.r.p ──unless≡1*/
        do k=1  for rows;  ?=@.k.!     /*subtract (row K)   @.r.s  from row K.*/
        if k==r | ?=0  then iterate    /*skip  if  row K is the same as row R.*/
            do s=1  for cols;  @.k.s=@.k.s - ?*@.r.s; end   /*s*/
        end    /*k*/                   /* [+]  for the rest of numbers in row.*/
  !=!+1                                /*bump the column pointer.             */
  end          /*r*/

call showMat  'matrix RREF'            /*display the reduced row echelon form.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
showMat: parse arg title;   say;    say center(title, 3+(cols+1)*w, '─');    say
   do      r=1  for rows;   _=
         do c=1  for cols
         if @.r.c==''  then do; say "***error!*** matrix element isn't defined:"
                                say 'row'   row", column"  c'.';   exit 13
                            end
         _=_ right(@.r.c,w)
         end   /*c*/
   say _                               /*display a row of the matrix to screen*/
   end         /*r*/
return
