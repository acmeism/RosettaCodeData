PRAGMAT precision=200 PRAGMAT
MODE INTEGER = LONG LONG INT;

LONG INT default integer width := 69;
INT width = 69+2;

INT fix w = 1, fix h = 1; # round up #

LONG LONG INT golden ratio w := ENTIER ((long long sqrt(5)-1) / 2 * LENG LENG 10 ** default integer width + fix w),
              golden ratio h := ENTIER ((long long sqrt(5)+1) / 2 * LENG LENG 10 ** default integer width + fix h);

test: (
  print((
    "The approximate golden ratios, width: ",  whole(golden ratio w,width), new line,
    "                              length: ", whole(golden ratio h,width), new line,
    "                product is exactly: ", whole(golden ratio w*golden ratio h,width*2), new line));

  INTEGER two to the power of 64 = LONG 2 ** 64;
  INTEGER neg two to the power of 64 = -(LONG 2 ** 64);
  print(("2 ** 64 * -(2 ** 64) = ", whole(two to the power of 64*neg two to the power of 64,width), new line))
)
