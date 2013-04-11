#!/usr/local/bin/a68g --script #

MODE COSCAL = COMPL;
PR READ "Matrix_algebra.a68" PR
PR READ "Matrix-exponentiation_operator.a68" PR

PROC compl mat printf= (FORMAT scal fmt, MAT m)VOID:(
  FORMAT
    vec math = $n(2 UPB m)(f(scal fmt)"&")$,
    mat math = $"<math>\begin{bmat}"ln(UPB m)(xxf(vec fmt)"\\"l)"\end{bmat}</math>"$,
    vec fmt = $"("n(2 UPB m-1)(f(scal fmt)",")f(scal fmt)")"$,
    mat fmt = $x"("n(UPB m-1)(f(vec fmt)","lxx)f(vec fmt)");"$;
  # finally print the result #
  printf((mat fmt,m))
);

FORMAT scal fmt = $-d.dddd,+d.dddd"i"$; # width of 4, with no leading '+' sign, 1 decimals #
MAT mat=((sqrt(0.5)I0         , sqrt(0.5)I0        , 0I0),
         (        0I-sqrt(0.5),         0Isqrt(0.5), 0I0),
         (        0I0         ,         0I0        , 0I1))

printf(($" mat ** "g(0)":"l$,24));
compl mat printf(scal fmt, mat**24);
print(newline)
