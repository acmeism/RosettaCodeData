module PrimeArray exposing (main)

import Array exposing (Array, foldr, map, set)
import Html exposing (div, h1, p, text)
import Html.Attributes exposing (style)


{-
The Eratosthenes sieve task in Rosetta Code does not accept the use of modulo function  (allthough Elm functions modBy and remainderBy work always correctly as they require type Int excluding type Float). Thus the solution needs an indexed work array as Elm has no indexes for lists.

In this method we need no division remainder calculations, as we just set the markings of non-primes into the array. We need the indexes that we know, where the marking of the non-primes shall be set.

Because everything is immutable in Elm, every change of array values will create a new array save the original array unchanged. That makes the program running slower or consuming more space of memory than with non-functional imperative languages. All conventional loops (for, while, until) are excluded in Elm because immutability requirement.

   Live: https://ellie-app.com/pTHJyqXcHtpa1
-}


alist =
    List.range 2 150



-- Work array contains integers 2 ... 149


workArray =
    Array.fromList alist


n : Int
n =
    List.length alist



-- The max index of integers used in search for primes
-- limit * limit < n
-- equal: limit <= √n


limit : Int
limit =
    round (0.5 + sqrt (toFloat n))


-- Remove zero cells of the array


findZero : Int -> Bool
findZero =
    \el -> el > 0


zeroFree : Array Int
zeroFree =
    Array.filter findZero workResult


nrFoundPrimes =
    Array.length zeroFree


workResult : Array Int
workResult =
    loopI 2 limit workArray



{- As Elm has no loops (for, while, until)
we must use recursion instead!
The search of prime starts allways saving the
first found value (not setting zero) and continues setting the multiples of prime to zero.
Zero is no integer and may thus be used as marking of non-prime numbers. At the end, only the primes remain in the array and the zeroes are removed from the resulted array to be shown in Html.
-}

-- The recursion increasing variable i follows:

loopI : Int -> Int -> Array Int -> Array Int
loopI i imax arr =
    if i > imax then
        arr

    else
        let
            arr2 =
                phase i arr
        in
        loopI (i + 1) imax arr2



-- The helper function


phase : Int -> Array Int -> Array Int
phase i =
    arrayMarker i (2 * i - 2) n


lastPrime =
    Maybe.withDefault 0 <| Array.get (nrFoundPrimes - 1) zeroFree


outputArrayInt : Array Int -> String
outputArrayInt arr =
    decorateString <|
        foldr (++) "" <|
            Array.map (\x -> String.fromInt x ++ " ") arr


decorateString : String -> String
decorateString str =
    "[ " ++ str ++ "]"



-- Recursively marking the multiples of p with zero
-- This loop operates with constant p


arrayMarker : Int -> Int -> Int -> Array Int -> Array Int
arrayMarker p min max arr =
    let
        arr2 =
            set min 0 arr

        min2 =
            min + p
    in
    if min < max then
        arrayMarker p min2 max arr2

    else
        arr


main =
    div [ style "margin" "2%" ]
        [ h1 [] [ text "Sieve of Eratosthenes" ]
        , text ("List of integers [2, ... ," ++ String.fromInt n ++ "]")
        , p [] [ text ("Total integers " ++ String.fromInt n) ]
        , p [] [ text ("Max prime of search " ++ String.fromInt limit) ]
        , p [] [ text ("The largest found prime " ++ String.fromInt lastPrime) ]
        , p [ style "color" "blue", style "font-size" "1.5em" ]
            [ text (outputArrayInt zeroFree) ]
        , p [] [ text ("Found " ++ String.fromInt nrFoundPrimes ++ " primes") ]
        ]
