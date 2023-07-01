/*REXX program  multiplies two matrices together, displays the matrices and the result. */
m= (1 2 3)  (4 5 6)  (7 8 9)
w= words(m);                    do rows=1;     if rows*rows>=w  then leave
                                end  /*k*/;            cols= rows
call showMat  M, 'M matrix'
ans= matOp(m, '+2'   );   call showMat  ans,  "M matrix, added 2"
ans= matOp(m, '-7'   );   call showMat  ans,  "M matrix, subtracted 7"
ans= matOp(m, '*2.5' );   call showMat  ans,  "M matrix, multiplied by 2½"
ans= matOp(m, '**3'  );   call showMat  ans,  "M matrix, cubed"
ans= matOp(m, '/4'   );   call showMat  ans,  "M matrix, divided by 4"
ans= matOp(m, '%2'   );   call showMat  ans,  "M matrix, integer halved"
ans= matOp(m, '//3'  );   call showMat  ans,  "M matrix, modulus 3"
ans= matOp(m, '*3-1' );   call showMat  ans,  "M matrix, tripled, less one"
exit 0                                           /*stick a fork in it,  we"re all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
matOp: parse arg @,#; call mat#; do j=1 for w; interpret '!.'j"=!."j #; end; return mat@()
mat#:  w= words(@);              do j=1 for w; !.j= word(@,j);          end; return
mat@:  @= !.1;                   do j=2  to w; @= @ !.j;                end; return @
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat:  parse arg @, hdr;                      L= 0;                               say
                             do j=1  for w;      L= max(L, length( word(@, j) ) );     end
          say;         say center(hdr,max(length(hdr)+4,cols*(L+1)+4),"─")
          n= 0
                 do r    =1  for rows;           _=
                     do c=1  for cols;  n= n+1;  _= _ right( word(@, n), L);  end;   say _
                 end
          return
