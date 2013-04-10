/*REXX program multiplies two matrixes together, shows matrixes & result*/
m=(1 2 3)  (4 5 6)  (7 8 9)
w=words(m);  do k=1; if k*k>=w then leave; end  /*k*/;     rows=k;  cols=k

call showMat  M, 'M matrix'
answer=matAdd(m, 2  );  call showMat  answer, 'M matrix, added 2'
answer=matSub(m, 7  );  call showMat  answer, 'M matrix, subtracted 7'
answer=matMul(m, 2.5);  call showMat  answer, 'M matrix, multiplied by 2½'
answer=matPow(m, 3  );  call showMat  answer, 'M matrix, cubed'
answer=matDiv(m, 4  );  call showMat  answer, 'M matrix, divided by 4'
answer=matIdv(m, 2  );  call showMat  answer, 'M matrix, integer halved'
answer=matMod(m, 3  );  call showMat  answer, 'M matrix, modulus 3'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWMAT subroutine──────────────────*/
showMat:  parse arg @, hdr;   say
L=0;               do j=1  for w;     L=max(L,length(word(@,j)));   end
say  center(hdr, max(length(hdr)+4, cols*(L+1)+4), "─")
n=0
        do r    =1 for rows;         _=
            do c=1 for cols; n=n+1;  _=_ right(word(@,n),L); end;    say _
        end
return
/*──────────────────────────────────one-liner subroutines───────────────*/
matAdd: arg @,#; call mat#;  do j=1 for w; !.j=!.j+#;  end;  return mat@()
matSub: arg @,#; call mat#;  do j=1 for w; !.j=!.j-#;  end;  return mat@()
matMul: arg @,#; call mat#;  do j=1 for w; !.j=!.j*#;  end;  return mat@()
matDiv: arg @,#; call mat#;  do j=1 for w; !.j=!.j/#;  end;  return mat@()
matIdv: arg @,#; call mat#;  do j=1 for w; !.j=!.j%#;  end;  return mat@()
matPow: arg @,#; call mat#;  do j=1 for w; !.j=!.j**#; end;  return mat@()
matMod: arg @,#; call mat#;  do j=1 for w; !.j=!.j//#; end;  return mat@()
mat#:   w=words(@);  do j=1  for w;  !.j=word(@,j);   end;   return
mat@:   @=!.1;       do j=2   to w;  @=@ !.j;         end;   return @
