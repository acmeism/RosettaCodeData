CREATE OR ALTER FUNCTION [dbo].[PGCD]
    (    @a BigInt
    ,    @b BigInt
    )
RETURNS BigInt
WITH RETURNS NULL ON NULL INPUT
-- Calculates the Greatest Common Denominator of two numbers (1 if they are coprime).
BEGIN
DECLARE @PGCD BigInt;

WITH    Vars(A, B)
As  (   SELECT  Max(V.N) As A
            ,   Min(V.N) As B
        FROM (  VALUES  ( Abs(@a) , Abs(@b)) ) Params(A, B)
        -- First, get absolute value
        Cross APPLY (   VALUES (Params.A) , (Params.B) ) V(N)
        -- Then, order parameters without Greatest/Least functions
        WHERE Params.A > 0
            And Params.B > 0 -- If 0 passed in, NULL shall be the output
    )
    ,   Calc(A, B)
As  (   SELECT  A
            ,   B
        FROM    Vars

        UNION ALL

        SELECT  B As A
            ,   A % B As B -- Self-ordering
        FROM    Calc
        WHERE   Calc.A > 0
            And Calc.B > 0
    )
SELECT  @PGCD = Min(A)
FROM    Calc
WHERE   Calc.B = 0
;

RETURN @PGCD;

END
