/*REXX program to perform  Reduced Row Echelon Form (RREF) on a matrix. */
cols=0                                 /*maximum columns in any row.    */
maxW=0                                 /*maximum width of any element.  */
@.=                                    /*matrix to be constructed.      */
mat.=
mat.1 = '   1   2   -1      -4  '
mat.2 = '   2   3   -1     -11  '
mat.3 = '  -2   0   -3      22  '

  do r=1  until mat.r=='';    _=mat.r  /*build  @.row.col  from  mat.n  */
                      do c=1  until _='';         parse var _ @.r.c _
                      maxW = max(maxW, length(@.r.c))
                      end   /*c*/
  cols = max(cols,c)
  end

rows =    r - 1                        /*adjust the row count.          */
maxW = maxW + 1                        /*bump the max width, better view*/
call showMat 'original matrix'         /*show the original matrix.      */
! = 1                                  /*set the pointer to one.        */
/*═══════════════════════════════════Reduced Row Echelon Form on matrix.*/
  do r=1  for rows  while cols>!       /*start to do the heavy lifting. */
  j=r
       do  while  @.j.!==0;     j = j+1
       if j==rows  then do
                        j = r
                        ! = ! + 1;     if cols==!  then leave r
                        end
       end  /*while*/

          do w=1  for cols while j\==r /*swap rows J,R (but not if same)*/
          parse value  @.r.w  @.j.w    with    @.j.w  @.w.w
          end   /*w*/
  ?=@.r.!
          do d=1  for cols while ?\=1  /*divide row J by @.r.p--unless 1*/
          @.r.d = @.r.d / ?
          end   /*d*/

             do k=1  for rows          /*sub (row K) *@.r.s  from row K */
             if k==r  then iterate     /*skip if row k is the same as R */
             ?=@.k.!
                     do s=1  for cols while ?\=0 /*but not if @.r.! is 0*/
                     @.k.s = @.k.s   -   ? * @.r.s
                     end   /*s*/
             end           /*k*/
  !=!+1
  end                      /*r*/

call showMat 'matrix RREF'             /*show reduced row echelon form. */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWMAT subroutine──────────────────*/
showMat:  parse arg title;   say
say center(title,3+(cols+1)*maxW,'─');  say      /*build a pretty title.*/

       do r         =1  for rows;      _=
                do c=1  for cols
                if @.r.c==''  then do;  say;   say '*** error! ***';   say
                                   say "matrix element isn't defined:"
                                   say  'row'  row", column"  c'.';    say
                                   exit 13
                                   end
                _ = _ right(@.r.c,maxW)
                end   /*c*/
       say _
       end    /*r*/
return
