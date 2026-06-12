module Lib (forward, inverse, self) where

-- Forward, inverse and self-inverting transformation differ only in potential negation of some summands
-- expressed as a list (for each term) of lists (for each summand) of negation or no negation (identity).

forward :: [Integer] -> [Integer]
forward = transform (repeat $ repeat id)
-- No negation at all.

inverse :: [Integer] -> [Integer]
inverse = transform (iterate (drop 1) $ cycle [id, negate])
-- Summands alternate between negation and no negation, next term starts with the opposite correction.

self :: [Integer] -> [Integer]
self = transform (repeat $ cycle [id, negate])
-- Summands alternate between negation and no negation, all terms use the same correction.

transform :: [[Integer -> Integer]] -> [Integer] -> [Integer]
transform sgn a = zipWith compute sgn (take (length a) pascal)
    where
        -- Compute a new term: First, multiply binomial coefficient from the respective pascal's triangle
        -- row with all previous terms, then apply signum correction to individual summands and sum them.
        compute fun row = sum $ zipWith ($) fun $ zipWith (*) row a

-- Generate the Pascal's triangle as an infinite List
pascal :: [[Integer]]
pascal = iterate (\row -> zipWith (+) (0 : row) (row ++ [0])) [1]
