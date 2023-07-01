DBZ(REAL8 Dividend,INTEGER8 Divisor) := Quotient/Divisor;

#option ('divideByZero', 'zero');
DBZ(10,0); //returns 0.0
