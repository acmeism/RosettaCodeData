/*REXX pgm implements main step GOST 28147-89 based on a Feistel network*/
numeric digits 12          /*  ┌── a list of 4─bit S─box values used by */
                           /*  ↓ the Central Bank of Russian Federation.*/
_.0  =     4  10   9   2  13   8   0  14   6  11   1  12   7  15   5   3
_.1  =    14  11   4  12   6  13  15  10   2   3   8   1   0   7   5   9
_.2  =     5   8   1  13  10   3   4   2  14  15  12   7   6   0   9  11
_.3  =     7  13  10   1   0   8   9  15  14   4   6  12  11   2   5   3
_.4  =     6  12   7   1   5  15  13   8   4  10   9  14   0   3  11   2
_.5  =     4  11  10   0   7   2   1  13   3   6   8   5   9  12  15  14
_.6  =    13  11   4   1   3  15   5   9   0  10  14   7   6   8   2  12
_.7  =     1  15  13   0   5   7  10   4   9   2   3  14   6  11   8  12
                                       /* [↑]  build the sub-keys array.*/
    do r=0  for 8;   do c=0  for 16;   !.r.c = word(_.r, c+1);   end;  end

#.1=x2d(43b0421);      #.2=x2d(4320430);       key=x2d(0e2c104f9);     z=0
k=#.1+key;   p=2**32
                           do  while  k>2147483647;   k = k - p;   end
                           do  while  k<2147483648;   k = k + p;   end

  do i=0  for 4;   $=x2d(right(d2x(k%2**(i*8)), 2))
  ii=i+i       ;   iip=ii+1            /*calculate array  "subscripts". */
  cm=$//16     ;   cd=$%16             /*perform modulus and integer div*/
  z=z + (!.ii.cm + 16*!.iip.cd) * 2**(i*8)
  end   /*i*/                          /* [↑] encryption algorithm S-box*/
                                       /* [↓] encryption algorithm round*/
k = c2d( bitxor( bitor( d2c(z* 2**11, 4), d2c(z% 2**21, 4)), d2c(#.2, 4)))
say  center(d2x(k)  d2x(#.1), 79)      /*display the (centered)  result.*/
                                       /*stick a fork in it, we're done.*/
