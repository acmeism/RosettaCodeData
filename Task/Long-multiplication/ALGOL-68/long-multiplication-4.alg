# The following standard operators could (potentially) also be defined #
OP -   = (INTEGER a)INTEGER: raise integer not implemented error("monadic minus"),
  ABS  = (INTEGER a)INTEGER: raise integer not implemented error("ABS"),
  ODD  = (INTEGER a)INTEGER: raise integer not implemented error("ODD"),
  BIN  = (INTEGER a)INTEGER: raise integer not implemented error("BIN");

OP +  = (INTEGER a, b)INTEGER: raise integer not implemented error("addition"),
   -  = (INTEGER a, b)INTEGER: raise integer not implemented error("subtraction"),
   /  = (INTEGER a, b)REAL: ( VOID(raise integer not implemented error("floating point division")); SKIP),
   %  = (INTEGER a, b)INTEGER: raise integer not implemented error("fixed point division"),
   %* = (INTEGER a, b)INTEGER: raise integer not implemented error("modulo division"),
   ** = (INTEGER a, b)INTEGER: raise integer not implemented error("to the power of");

LONG INT default integer width := long long int width - 2;

INT fix w = -1177584, fix h = -3915074; # floating point error, probably GMP/hardware specific #

INTEGER golden ratio w := INTEGERINIT ENTIER ((long long sqrt(5)-1) / 2 * LENG LENG 10 ** default integer width + fix w),
        golden ratio h := INTEGERINIT ENTIER ((long long sqrt(5)+1) / 2 * LENG LENG 10 ** default integer width + fix h);

test: (
  print((
    "The approximate golden ratios, width: ",  REPR golden ratio w, new line,
    "                            length: ", REPR golden ratio h, new line,
    "                product is exactly: ", REPR (golden ratio w * golden ratio h), new line));

  INTEGER two to the power of 64 = INTEGERINIT(LONG 2 ** 64);
  INTEGER neg two to the power of 64 = INTEGERINIT(-(LONG 2 ** 64));
  print(("2 ** 64 * -(2 ** 64) = ", REPR (two to the power of 64 * neg two to the power of 64), new line))
)
