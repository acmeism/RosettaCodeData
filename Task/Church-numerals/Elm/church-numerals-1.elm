module Main exposing ( main )

import Html exposing ( Html, text )

type alias Church a = (a -> a) -> a -> a

churchZero : Church a -- a Church constant
churchZero = always identity

succChurch : Church a -> Church a
succChurch ch = \ f -> f << ch f -- add one recursion

addChurch : Church a -> Church a -> Church a
addChurch chaf chbf = \ f -> chaf f << chbf f

multChurch : Church a -> Church a -> Church a
multChurch = (<<)

expChurch : Church a -> (Church a -> Church a) -> Church a
expChurch = (\ f x y -> f y x) identity -- `flip` inlined

churchFromInt : Int -> Church a
churchFromInt n = if n <= 0 then churchZero
                  else succChurch <| churchFromInt (n - 1)

intFromChurch : Church Int -> Int
intFromChurch cn = cn ((+) 1) 0 -- `succ` inlined

--------------------------- TEST -------------------------
main : Html Never
main =
  let cThree = churchFromInt 3
      cFour = succChurch cThree
  in [ addChurch cThree cFour
     , multChurch cThree cFour
     , expChurch cThree cFour
     , expChurch cFour cThree
     ] |> List.map intFromChurch
       |> Debug.toString |> text
