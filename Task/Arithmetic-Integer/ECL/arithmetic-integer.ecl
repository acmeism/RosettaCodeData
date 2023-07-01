ArithmeticDemo(INTEGER A,INTEGER B) := FUNCTION
  ADDit       := A + B;
  SUBTRACTit  := A - B;
  MULTIPLYit  := A * B;
  INTDIVIDEit := A DIV B; //INTEGER DIVISION
  DIVIDEit    := A / B;   //standard division
  Remainder   := A % B;
  EXPit       := POWER(A,B);
  DS          := DATASET([{A,B,'A PLUS B is:',ADDit},
                          {A,B,'A MINUS B is:',SUBTRACTit},
			  {A,B,'A TIMES B is:',MULTIPLYit},
			  {A,B,'A INT DIVIDE BY B is:',INTDIVIDEit},
			  {A,B,'REMAINDER is:',Remainder},
			  {A,B,'A DIVIDE BY B is:',DIVIDEit},
			  {A,B,'A RAISED TO B:',EXPit}],
			  {INTEGER AVal,INTEGER BVal,STRING18 valuetype,STRING val});
										
  RETURN DS;
  END;
	
ArithmeticDemo(1,1);
ArithmeticDemo(2,2);
ArithmeticDemo(50,5);
ArithmeticDemo(10,3);
ArithmeticDemo(-1,2);
	
/* 	NOTE:Division by zero defaults to generating a zero result (0),
   	rather than reporting a “divide by zero” error.
   	This avoids invalid or unexpected data aborting a long job.
   	This default behavior can be changed
*/
