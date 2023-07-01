main:
(
  FILE fbuf; STRING sbuf;

  OP FBUF = (STRING in sbuf)REF FILE: (
    sbuf := in sbuf;
    associate(fbuf, sbuf);
    fbuf
  );

  BITS num;

  getf(FBUF("0123459"), ($10r7d$, num));
  printf(($gl$, ABS num)); # prints 123459 #

  getf(FBUF("abcf123"), ($16r7d$, num));
  printf(($gl$, ABS num)); # prints 180154659 #

  getf(FBUF("7651"), ($8r4d$, num));
  printf(($gl$, ABS num)); # prints 4009 #

  getf(FBUF("1010011010"), ($2r10d$, num));
  printf(($gl$, ABS num)) # prints 666 #

)
