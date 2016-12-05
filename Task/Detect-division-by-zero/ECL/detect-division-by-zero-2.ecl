DBZ(REAL8 Dividend,INTEGER8 Divisor) := Quotient/Divisor;
#option ('divideByZero', 'fail');
DBZ(10,0); //returns error message "Error:    System error: -1: Division by zero (0, 0), -1,"
