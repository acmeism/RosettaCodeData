USING: kernel math math.functions monads prettyprint ;
FROM: monads => do ;

{
    [ 5 "Started with five, " <writer> ]
    [ sqrt "took square root, " <writer> ]
    [ 1 + "added one, " <writer> ]
    [ 2 / "divided by two." <writer> ]
} do .
