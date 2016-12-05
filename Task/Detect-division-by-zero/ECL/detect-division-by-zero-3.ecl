DBZ(REAL8 Dividend,INTEGER8 Divisor) := Quotient/Divisor;
#option ('divideByZero', 'nan');
DBZ(10,0); //returns 'nan'

/* NOTE: This is only currently supported for real numbers. Division by zero creates a quiet NaN,
   which will propogate through any real expressions it is used in.
   You can use NOT ISVALID(x) to test if the value is a NaN.
   Integer and decimal division by zero continue to return 0.
*/
