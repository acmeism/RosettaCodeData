INT max abs bit = ABS(BIN 1 SHL 1)-1;
INT bits per char = ENTIER (ln(max abs char+1)/ln(max abs bit+1));
INT bits per int = ENTIER (1+ln(max int+1.0)/ln(max abs bit+1));

printf(($"states per bit: "dl$,max abs bit+1));
printf(($"bits per char: "z-dl$,bits per char));
printf(($"bits per int:  "z-dl$,bits per int));
printf(($"chars per int: "z-dl$,bits per int OVER bits per char));

printf(($"bits width: "z-dl$, bits width));

STRING abcds = "ABCD";
FILE abcdf;
INT abcdi;

INT errno := open(abcdf, "abcd.dat",stand back channel);
put(abcdf,abcds); # output alphabetically #
reset(abcdf);
get bin(abcdf,abcdi); # input in word byte order #
STRING int byte order := "";
FOR shift FROM 0 BY bits per char TO bits per int - bits per char DO
  int byte order +:= REPR(abcdi OVER (max abs bit+1) ** shift MOD (max abs char+1))
OD;
printf(($"int byte order: "g,", Hex:",16r8dl$,int byte order, BIN abcdi))
