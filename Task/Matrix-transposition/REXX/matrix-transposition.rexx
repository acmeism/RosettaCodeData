/*REXX program transposes any sized rectangular matrix, displays before & after matrices*/
@.=;     @.1 =   1.02     2.03      3.04       4.05        5.06         6.07          7.08
         @.2 = 111     2222     33333     444444     5555555     66666666     777777777
w=0
                             do    row=1  while @.row\==''
                                do col=1  until @.row==''; parse var @.row A.row.col @.row
                                w=max(w, length(A.row.col) )    /*max width for elements*/
                                end   /*col*/                   /*(used to align ouput).*/
                             end      /*row*/    /* [↑]  build matrix A from the @ lists*/
row= row-1                                       /*adjust for  DO  loop index increment.*/
                             do    j=1  for row  /*process each    row    of the matrix.*/
                                do k=1  for col  /*   "      "    column   "  "     "   */
                                B.k.j= A.j.k     /*transpose the  A  matrix  (into  B). */
                                end   /*k*/
                             end      /*j*/
call showMat  'A', row, col                      /*display the   A   matrix to terminal.*/
call showMat  'B', col, row                      /*   "     "    B      "    "     "    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: arg mat,rows,cols;     say;       say center( mat  'matrix',  (w+1)*cols +4, "─")
                 do      r=1  for rows;    _=                                  /*newLine*/
                      do c=1  for cols;    _=_ right( value( mat'.'r"."c), w)  /*append.*/
                      end   /*c*/
                 say _                                                         /*1 line.*/
                 end        /*r*/;         return
