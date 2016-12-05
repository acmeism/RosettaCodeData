CREATE FUNCTION fib(n int) RETURNS numeric AS $$
    -- This recursive with generates endless list of Fibonacci numbers.
    WITH RECURSIVE fibonacci(current, previous) AS (
        -- Initialize the current with 0, so the first value will be 0.
        -- The previous value is set to 1, because its only goal is not
        -- special casing the zero case, and providing 1 as the second
        -- number in the sequence.
        --
        -- The numbers end with dots to make them numeric type in
        -- Postgres. Numeric type has almost arbitrary precision
        -- (technically just 131,072 digits, but that's good enough for
        -- most purposes, including calculating huge Fibonacci numbers)
        SELECT 0., 1.
    UNION ALL
        -- To generate Fibonacci number, we need to add together two
        -- previous Fibonacci numbers. Current number is saved in order
        -- to be accessed in the next iteration of recursive function.
        SELECT previous + current, current FROM fibonacci
    )
    -- The user is only interested in current number, not previous.
    SELECT current FROM fibonacci
    -- We only need one number, so limit to 1
    LIMIT 1
    -- Offset the query by the requested argument to get the correct
    -- position in the list.
    OFFSET n
$$ LANGUAGE SQL RETURNS NULL ON NULL INPUT IMMUTABLE;
