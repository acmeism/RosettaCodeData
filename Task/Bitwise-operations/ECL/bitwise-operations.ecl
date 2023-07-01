BitwiseOperations(INTEGER A, INTEGER B) := FUNCTION
  BitAND := A & B;
  BitOR  := A | B;
  BitXOR := A ^ B;
  BitNOT := BNOT A;
  BitSL  := A << B;
  BitSR  := A >> B;
  DS     := DATASET([{A,B,'Bitwise AND:',BitAND},
	             {A,B,'Bitwise OR:',BitOR},
		     {A,B,'Bitwise XOR',BitXOR},
		     {A,B,'Bitwise NOT A:',BitNOT},
		     {A,B,'ShiftLeft A:',BitSL},
		     {A,B,'ShiftRight A:',BitSR}],
		     {INTEGER AVal,INTEGER BVal,STRING15 valuetype,INTEGER val});
  RETURN DS;
END;

BitwiseOperations(255,5);
//right arithmetic shift, left and right rotate not implemented
/*
   OUTPUT:
   255	5	Bitwise AND:   	5
   255	5	Bitwise OR:    	255
   255	5	Bitwise XOR    	250
   255	5	Bitwise NOT A: 	-256
   255	5	ShiftLeft A:   	8160
   255	5	ShiftRight A:  	7

*/
