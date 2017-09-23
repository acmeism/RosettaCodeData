/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: arg mat,rows,cols;     say;       say center( mat  'matrix',  (L+1)*cols +4, "─")
         $=.
                 do      r=1  for rows;    _=
                      do c=1  for cols;    _=_ right( value( mat || $ || r || $ || c),  L)
                      end   /*c*/
                 say _
                 end        /*r*/;         return
