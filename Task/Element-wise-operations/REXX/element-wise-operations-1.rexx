/*REXX program  multiplies two matrices together, displays the  matrices and the result.*/
m= (1 2 3)  (4 5 6)  (7 8 9)
w= words(m);                   do rows=1;       if rows*rows>=w  then leave
                               end   /*rows*/
cols= rows
call showMat  M, 'M matrix'
answer= matAdd(m, 2  );   call showMat answer, 'M matrix, added 2'
answer= matSub(m, 7  );   call showMat answer, 'M matrix, subtracted 7'
answer= matMul(m, 2.5);   call showMat answer, 'M matrix, multiplied by 2½'
answer= matPow(m, 3  );   call showMat answer, 'M matrix, cubed'
answer= matDiv(m, 4  );   call showMat answer, 'M matrix, divided by 4'
answer= matIdv(m, 2  );   call showMat answer, 'M matrix, integer halved'
answer= matMod(m, 3  );   call showMat answer, 'M matrix, modulus 3'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
matAdd:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j+#;     end;  return mat@()
matSub:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j-#;     end;  return mat@()
matMul:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j*#;     end;  return mat@()
matDiv:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j/#;     end;  return mat@()
matIdv:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j%#;     end;  return mat@()
matPow:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j**#;    end;  return mat@()
matMod:   parse arg @,#;  call mat#;   do j=1  for w;  !.j= !.j//#;    end;  return mat@()
mat#:     w= words(@);                 do j=1  for w;  !.j= word(@,j); end;  return
mat@:     @= !.1;                      do j=2   to w;  @=@ !.j;        end;  return @
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat:  parse arg @, hdr;                    L= 0;                                 say
                               do j=1  for w;  L= max(L, length( word(@,j) ) ); end
          say  center(hdr, max( length(hdr)+4, cols * (L+1)+4), "─")
          n= 0
                  do     r=1  for rows;           _=
                      do c=1  for cols;  n= n+1;  _= _ right( word(@, n), L);   end; say _
                  end
          return
