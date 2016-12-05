LogicalOperations(BOOLEAN A,BOOLEAN B) := FUNCTION
  ANDit := A AND B;
  ORit  := A OR B;
  NOTA  := NOT A;
  XORit := (A OR B) AND NOT (A AND B);
  DS    := DATASET([{A,B,'A AND B is:',ANDit},
                    {A,B,'A OR B is:',ORit},
                    {A,B,'NOT A is:',NOTA},
                    {A,B,'A XOR B is:',XORit}],
                    {BOOLEAN AVal,BOOLEAN BVal,STRING11 valuetype,BOOLEAN val});
  RETURN DS;
END;

LogicalOperations(FALSE,FALSE);
LogicalOperations(FALSE,TRUE);
LogicalOperations(TRUE,FALSE);
LogicalOperations(TRUE,TRUE);
LogicalOperations(1>2,1=1); //Boolean expressions are also valid here
