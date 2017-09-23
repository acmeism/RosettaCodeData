/*REXX program transposes any sized rectangular matrix, displays before & after matrices*/
@.=;     @.1 =   1.02     2.03      3.04       4.05        5.06         6.07          7.08
         @.2 = 111     2222     33333     444444     5555555     66666666     777777777
                           do    row=1  while @.row\==''
                              do col=1  while @.row\=='';  parse var @.row A.row.col @.row
                              end   /*c*/
                           end      /*r*/        /* [↑]  build matrix  A  from matrix  X*/
rows=row-1;  cols=col-1                          /*adjust for the  DO  loop  indices.   */
L=0;                       do    j=1  for rows
                              do k=1  for cols
                              B.k.j=A.j.k;           L=max( L, length(B.k.j) )
                              end   /*k*/        /*  ↑                                  */
                           end      /*j*/        /*  └─── is maximum width element value*/
call showMat 'A',rows,cols
call showMat 'B',cols,rows
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: arg mat,rows,cols;     say;       say center( mat  'matrix',  (L+1)*cols +4, "─")
                 do      r=1  for rows;    _=
                      do c=1  for cols;    _=_ right( value( mat'.'r"."c),  L)
                      end   /*c*/
                 say _
                 end        /*r*/;         return
