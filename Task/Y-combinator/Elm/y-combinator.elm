module Main exposing ( main )

import Html exposing ( Html, text )

-- Recursive wrapper Type required for statically-typed languages...
type Mu a = Roll (Mu a -> a)
unroll : Mu a -> (Mu a -> a)
unroll (Roll v) = v

-- the non-sharing non-recursive implementation of the Z-Combinator...
fixz : ((a -> b) -> (a -> b)) -> (a -> b)
fixz f = let g = \ x v -> f (unroll x x) v in g (Roll g)

facz : Int -> Int
-- facz = fixz <| \ f n -> if n < 2 then 1 else n * f (n - 1) -- inefficient recursion
facz = fixz (\ f n i -> if i < 2 then n else f (i * n) (i - 1)) 1 -- efficient tailcall

fibz : Int -> Int
-- fibz = fixz <| \ f n -> if n < 2 then n else f (n - 1) + f (n - 2) -- inefficient recursion
fibz = fixz (\ fn f s i -> if i < 2 then f else fn s (f + s) (i - 1)) 1 1 -- efficient tailcall

-- the non-sharing non-recursive implementation of fixy with injected laziness...
-- this works for languages that are "strict" = non-lazy by default...
fixy : ((() -> a) -> a) -> a
fixy f = let g x = f <| \ () -> (unroll x) x in g (Roll g)

{-- } --as Elm allows function recursion, the above is equivalent to the following:
fixy f = f <| \ () -> fixy f
--}

-- sharing version if `(() -> a)` is lazy memoizing value of `a` - Elm doesn't have memoization!
fix : ((() -> a) -> a) -> a -- however, it works as a Y Combinator...
fix f = let x() = f x in x()

facy : Int -> Int
-- facy = fixy <| \ f n -> if n < 2 then 1 else n * f () (n - 1) -- inefficient recursion
facy = fixy (\ f n i -> if i < 2 then n else f () (i * n) (i - 1)) 1 -- efficient tailcall

fiby : Int -> Int
-- fiby = fixy <| \ f n -> if n < 2 then n else f () (n - 1) + f (n - 2) -- inefficient recursion
fiby = fixy (\ fn f s i -> if i < 2 then f else fn () s (f + s) (i - 1)) 1 1 -- efficient tailcall

-- Something that can be done with the true Y-Combinator that can't be done with Z-Combinator...

-- defines a Co-Inductive Lazy (non-memoizing, just deferred) Stream...
type CIS a = CIS a (() -> CIS a)

mapCIS : (a -> b) -> CIS a -> CIS b -- uses function to map
mapCIS cf cis =
  let mp (CIS head restf) = CIS (cf head) <| \ () -> mp (restf()) in mp cis

iterateCISWithFrom : (CIS a -> CIS a) -> a -> CIS a
iterateCISWithFrom f v = fixy (\ dfn -> f (CIS v dfn))

fibsfunc : CIS (Int, Int) -> CIS (Int, Int)
fibsfunc = fixy (\ dfn -> \ (CIS ((cur, nxt) as hd) tlf) ->
                     CIS hd <| \ () -> dfn () (CIS (nxt, (cur + nxt)) tlf))

fibs : CIS Int
fibs = iterateCISWithFrom fibsfunc (1, 1) |> mapCIS (\ (v, _) -> v)

nCISs2String : Int -> CIS a -> String -- convert n CIS's to String
nCISs2String n cis =
  let loop i (CIS head restf) rslt =
        if i <= 0 then rslt ++ " )" else
        loop (i - 1) (restf()) (rslt ++ " " ++ Debug.toString head)
  in loop n cis "("

main : Html Never
main =
  String.fromInt (facz 10) ++ " " ++ String.fromInt (fibz 10)
    ++ " " ++ String.fromInt (facy 10) ++ " " ++ String.fromInt (fiby 10)
    ++ " " ++ nCISs2String 20 fibs
      |> text
