#!/usr/local/bin/a68g --script #

MODE SCALAR = REAL;
FORMAT scalar fmt = $g(0, 2)$;

MODE MATRIX = [3, 3]SCALAR;
FORMAT vector fmt = $"("n(2 UPB LOC MATRIX - 2 LWB LOC MATRIX)(f(scalar fmt)", ")f(scalar fmt)")"$;
FORMAT matrix fmt = $"("n(1 UPB LOC MATRIX - 1 LWB LOC MATRIX)(f(vector fmt)","l" ")f(vector fmt)")"$;

PROC elementwise op = (PROC(SCALAR, SCALAR)SCALAR op, MATRIX a, UNION(SCALAR, MATRIX) b)MATRIX: (
  [LWB a:UPB a, 2 LWB a:2 UPB a]SCALAR out;
  CASE b IN
  (SCALAR b):
    FOR i FROM LWB out TO UPB out DO
      FOR j FROM 2 LWB out TO 2 UPB out DO
        out[i, j]:=op(a[i, j], b)
      OD
    OD,
  (MATRIX b):
    FOR i FROM LWB out TO UPB out DO
      FOR j FROM 2 LWB out TO 2 UPB out DO
        out[i, j]:=op(a[i, j], b[i, j])
      OD
    OD
  ESAC;
  out
);

PROC plus  = (SCALAR a, b)SCALAR: a+b,
     minus = (SCALAR a, b)SCALAR: a-b,
     times = (SCALAR a, b)SCALAR: a*b,
     div   = (SCALAR a, b)SCALAR: a/b,
     pow   = (SCALAR a, b)SCALAR: a**b;

main:(
    SCALAR scalar := 10;
    MATRIX matrix = (( 7, 11, 13),
                     (17, 19, 23),
                     (29, 31, 37));

    printf(($f(matrix fmt)";"l$,
      elementwise op(plus,  matrix, scalar),
      elementwise op(minus, matrix, scalar),
      elementwise op(times, matrix, scalar),
      elementwise op(div,   matrix, scalar),
      elementwise op(pow,   matrix, scalar),

      elementwise op(plus,  matrix, matrix),
      elementwise op(minus, matrix, matrix),
      elementwise op(times, matrix, matrix),
      elementwise op(div,   matrix, matrix),
      elementwise op(pow,   matrix, matrix)
  ))
)
