WITH    OneToTen (N)
AS  (   SELECT  N
        FROM (  VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)
                ) V(N)
        )
    ,   InitDoors (Num, IsOpen)
AS  (   SELECT  1
            +   1 * Units.N
            +   10 * Tens.N As Num
            ,   Convert(Bit, 0) As IsOpen
        FROM    OneToTen As Units
        CROSS JOIN  OneToTen As Tens
        ) -- This part could be easier with a tally table or equivalent table-valued function
    ,   States (NbStep, Num, IsOpen)
AS  (   SELECT  0 As NbStep
            ,   Num
            ,   IsOpen
        FROM    InitDoors As InitState
        UNION ALL
        SELECT  1 + NbStep
            ,   Num
            ,   CASE Num % (1 + NbStep)
                    WHEN 0 THEN ~IsOpen
                    ELSE IsOpen
                END
        FROM    States
        WHERE   NbStep < 100
        )
SELECT  Num As DoorNumber
    ,   Concat( 'Door number ', Num, ' is '
            ,   CASE IsOpen
                    WHEN 1 THEN ' open'
                    ELSE ' closed'
                END ) As Result -- Concat needs SQL Server 2012
FROM    States
WHERE   NbStep = 100
ORDER By Num
; -- Fortunately, maximum recursion is 100 in SQL Server.
-- For more doors, the MAXRECURSION hint should be used.
-- More doors would also need an InitDoors with more rows.
