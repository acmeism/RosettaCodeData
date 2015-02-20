/*REXX pgm performs a  conjugate transpose  on a  complex square matrix.*/
parse arg N elements;  if N=='' then N=3
M.=0                                   /*Matrix has all elements = zero.*/
k=0;   do   r=1  for N
         do c=1  for N; k=k+1; M.r.c=word(word(elements,k) 1,1); end /*c*/
       end   /*r*/

call showCmat 'M'        ,N            /*display a nice formatted matrix*/
identity.=0;   do  d=1  for N;  identity.d.d=1;   end /*d*/
call conjCmat 'MH', "M"  ,N            /*conjugate the M matrix ───► MH */
call showCmat 'MH'       ,N            /*display a nice formatted matrix*/
say 'M is Hermitian:  '    word('no yes',isHermitian('M',"MH",N)+1)
call multCmat 'M',  'MH', 'MMH',  N    /*multiple two matrices together.*/
call multCmat 'MH', 'M',  'MHM',  N    /*    "     "     "        "     */
say '  M is Normal:   '    word('no yes',isHermitian('MMH',"MHM",N)+1)
say '  M is Unary:    '    word('no yes',isUnary('M',N)+1)
say 'MMH is Unary:    '    word('no yes',isUnary('MMH',N)+1)
say 'MHM is Unary:    '    word('no yes',isUnary('MHM',N)+1)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────CONJCMAT subroutine─────────────────*/
conjCmat: arg matX,matY,rows 1 cols;   call normCmat matY,rows
         do   r=1  for rows;  _=
           do c=1  for cols;  v=value(matY'.'r"."c)
           rP=rP(v);    cP=-cP(v);    call value  matX'.'c"."r, rP','cP
           end   /*c*/
         end     /*r*/
return
/*──────────────────────────────────ISHERMITIAN subroutine──────────────*/
isHermitian: arg matX,matY,rows 1 cols;    call normCmat matX,rows
                                           call normCmat matY,rows
         do   r=1  for rows;  _=
           do c=1  for cols
           if value(matX'.'r"."c)\=value(matY'.'r"."c)  then return 0
           end   /*c*/
         end     /*r*/
return 1
/*──────────────────────────────────ISUNARY subroutine──────────────────*/
isUnary: arg matX,rows 1 cols
            do   r=1  for rows;  _=
              do c=1  for cols;  z=value(matX'.'r"."c); rP=rP(z); cP=cP(z)
              if abs(sqrt(rP(z)**2+cP(z)**2)-(r==c))>=.0001  then return 0
            end   /*c*/
          end     /*r*/
return 1
/*──────────────────────────────────MULTCMAT subroutine─────────────────*/
multCmat: arg matA,matB,matT,rows 1 cols;  call value matT'.',0
  do     r=1  for rows;  _=
    do   c=1  for cols
      do k=1  for cols;  T=value(matT'.'r"."c);  Tr=rP(T);  Tc=cP(T)
                         A=value(matA'.'r"."k);  Ar=rP(A);  Ac=cP(A)
                         B=value(matB'.'k"."c);  Br=rP(B);  Bc=cP(B)
      Pr=Ar*Br-Ac*Bc;    Pc=Ac*Br+Ar*Bc;         Tr=Tr+Pr;     Tc=Tc+Pc
      call value matT'.'r"."c,Tr','Tc
      end   /*k*/
    end     /*c*/
  end       /*r*/
return
/*──────────────────────────────────NORMCMAT subroutine─────────────────*/
normCmat: arg matN,rows 1 cols
   do   r=1  to rows;  _=
     do c=1  to cols;  v=translate(value(matN'.'r"."c),,"IiJj")
     parse upper var v real ',' cplx
     if real\=='' then real=real/1
     if cplx\=='' then cplx=cplx/1;  if cplx=0 then cplx=
     if cplx\=='' then cplx=cplx"j"
     call value matN'.'r"."c,strip(real','cplx,"T",',')
     end   /*c*/
   end     /*r*/
return
/*──────────────────────────────────SHOWCMAT subroutine─────────────────*/
showCmat: arg matX,rows,cols;  if cols==''  then cols=rows; pad=left('',6)
say;  say center('matrix' matX,79,'─'); call normCmat matX,rows,cols
             do        r=1  to rows;  _=
                    do c=1  to cols;  _=_ pad left(value(matX'.'r"."c),9)
                    end   /*c*/
             say _
             end     /*r*/
say;   return
/*──────────────────────────────────one─liner subroutines───────────────*/
cP: procedure;  arg ',' p;   return word(strip(translate(p,,'IJ')) 0,1)
rP: procedure;  parse arg r ',';  return word(r 0,1)
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;  parse arg x;  if x=0 then return 0;   d=digits()
  numeric digits 11; g=.sqrtGuess(); do j=0 while p>9; m.j=p; p=p%2+1; end
  do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g);end
  numeric digits d;  return g/1
.sqrtGuess:       numeric form;     m.=11;              p=d+d%4+2
  parse value format(x,2,1,,0) 'E0' with g 'E' _ .;     return  g*.5'E'_%2
