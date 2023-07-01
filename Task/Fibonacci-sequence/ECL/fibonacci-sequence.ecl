//Calculates Fibonacci sequence up to n steps using Binet's closed form solution


FibFunction(UNSIGNED2 n) := FUNCTION
	REAL Sqrt5 := Sqrt(5);
	REAL Phi := (1+Sqrt(5))/2;
	REAL Phi_Inv := 1/Phi;
	UNSIGNED FibValue := ROUND( ( POWER(Phi,n)-POWER(Phi_Inv,n) ) /Sqrt5);
	RETURN FibValue;
	END;

 FibSeries(UNSIGNED2 n) := FUNCTION

 Fib_Layout := RECORD
 UNSIGNED5 FibNum;
 UNSIGNED5 FibValue;
 END;

 FibSeq := DATASET(n+1,
  TRANSFORM
 ( Fib_Layout
 , SELF.FibNum := COUNTER-1
 , SELF.FibValue := IF(SELF.FibNum<2,SELF.FibNum, FibFunction(SELF.FibNum) )
 )
 );

 RETURN FibSeq;

 END; }
