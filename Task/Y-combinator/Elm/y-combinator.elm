module Main exposing ( main )

import Html exposing ( Html, text )

-- As with most of the strict (non-deferred or non-lazy) languages,
-- this is the Z-combinator with the additional value parameter...

-- wrap type conversion to avoid recursive type definition...
type Mu a b = Roll (Mu a b -> a -> b)

unroll : Mu a b -> (Mu a b -> a -> b) -- unwrap it...
unroll (Roll x) = x

-- note lack of beta reduction using values...
fixz : ((a -> b) -> (a -> b)) -> (a -> b)
fixz f = let g r = f (\ v -> unroll r r v) in g (Roll g)

facz : Int -> Int
-- facz = fixz <| \ f n -> if n < 2 then 1 else n * f (n - 1) -- inefficient recursion
facz = fixz (\ f n i -> if i < 2 then n else f (i * n) (i - 1)) 1 -- efficient tailcall

fibz : Int -> Int
-- fibz = fixz <| \ f n -> if n < 2 then n else f (n - 1) + f (n - 2) -- inefficient recursion
fibz = fixz (\ fn f s i -> if i < 2 then f else fn s (f + s) (i - 1)) 1 1 -- efficient tailcall

-- by injecting laziness, we can get the true Y-combinator...
-- as this includes laziness, there is no need for the type wrapper!
fixy : ((() -> a) -> a) -> a
fixy f = f <| \ () -> fixy f -- direct function recursion
-- the above is not value recursion but function recursion!
-- the below is an attempt at value recursion, but...
-- fixv f = let x = f x in x -- not allowed by task or by Elm!
-- we can make Elm allow it by injecting laziness but...
fix : ((() -> a) -> a) -> a
fix f = let xf() = f xf in xf() -- this is just another form of function recursion...
-- the above is what the Haskell `fix` non-sharing fix point combinator actually is
-- because all values are actually non-strict/lazy, meaning they require a "thunk" as
-- above to be evaluated to their actual value, which is equivalent to `xf() ==> x` above!
-- thus, in Haskell, all "boxed" values such as this actually represent function applications!

facy : Int -> Int
-- facy = fixy <| \ f n -> if n < 2 then 1 else n * f () (n - 1) -- inefficient recursion
facy = fixy (\ f n i -> if i < 2 then n else f () (i * n) (i - 1)) 1 -- efficient tailcall

fiby : Int -> Int
-- fiby = fixy <| \ f n -> if n < 2 then n else f () (n - 1) + f (n - 2) -- inefficient recursion
fiby = fixy (\ fn f s i -> if i < 2 then f else fn () s (f + s) (i - 1)) 1 1 -- efficient tailcall

-- something that can be done with a true Y-Combinator that
-- can't be done with the Z combinator...
-- given an infinite Co-Inductive Stream (CIS) defined as...
type CIS a = CIS a (() -> CIS a) -- infinite lazy stream!

mapCIS : (a -> b) -> CIS a -> CIS b -- uses function to map
mapCIS cf cis =
  let mp (CIS head restf) = CIS (cf head) <| \ () -> mp (restf()) in mp cis

-- now we can define a Fibonacci stream as follows...
fibs : () -> CIS Int
fibs() = -- two recursive fix's, second already lazy...
  let fibsgen = fixy (\ fn (CIS (f, s) restf) ->
        CIS (s, f + s) (\ () -> fn () (restf())))
  in fixy (\ cisthnk -> fibsgen (CIS (0, 1) cisthnk))
       |> mapCIS (\ (v, _) -> v)

nCISs2String : Int -> CIS a -> String -- convert n CIS's to String
nCISs2String n cis =
  let loop i (CIS head restf) rslt =
        if i <= 0 then rslt ++ " )" else
        loop (i - 1) (restf()) (rslt ++ " " ++ Debug.toString head)
  in loop n cis "("

-- unfortunately, if we need CIS memoization so as
-- to make a true lazy list, Elm doesn't support it!!!

main : Html Never
main =
  String.fromInt (facz 10) ++ " " ++ String.fromInt (fibz 10)
    ++ " " ++ String.fromInt (facy 10) ++ " " ++ String.fromInt (fiby 10)
    ++ " " ++ nCISs2String 20 (fibs())
      |> text
