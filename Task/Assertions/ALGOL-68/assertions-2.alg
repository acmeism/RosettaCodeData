PROGRAM assertions CONTEXT VOID
USE standard,environment
BEGIN
  INT a := 43;
  "Oops!" ASSERT ( a = 42 )
END
FINISH
