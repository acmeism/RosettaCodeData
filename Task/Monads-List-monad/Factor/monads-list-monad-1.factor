USING: kernel math monads prettyprint ;
FROM: monads => do ;

{ 3 4 5 }
>>= [ 1 + array-monad return ] swap call
>>= [ 2 * array-monad return ] swap call .
