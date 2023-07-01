       REAL*8		BAD,NaN			!Sometimes a number is not what is appropriate.
       PARAMETER (NaN = Z'FFFFFFFFFFFFFFFF')	!This value is recognised in floating-point arithmetic.
       PARAMETER (BAD = Z'FFFFFFFFFFFFFFFF')	!I pay special attention to BAD values.
       CHARACTER*3	BADASTEXT		!Speakable form.
       DATA		BADASTEXT/" ? "/	!Room for "NaN", short for "Not a Number", if desired.
       REAL*8		PINF,NINF		!Special values. No sign of an "overflow" state, damnit.
       PARAMETER (PINF = Z'7FF0000000000000')	!May well cause confusion
       PARAMETER (NINF = Z'FFF0000000000000')	!On a cpu not using this scheme.
