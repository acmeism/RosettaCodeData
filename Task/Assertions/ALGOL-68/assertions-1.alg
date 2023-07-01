OP      ASSERT = (VECTOR [] CHAR assertion,BOOL valid) VOID:
IF      NOT valid
THEN    type line on terminal(assertion);
        terminal error( 661 {invalid assertion } )
FI;
