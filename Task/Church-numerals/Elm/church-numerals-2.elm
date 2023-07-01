module Main exposing (main)

import Html exposing (text)

-- the Church wrapper and functions...
type Church a = Church (Church a -> Church a)
              | ArityZero a -- treat a value as a function
applyChurch : Church a -> Church a -> Church a
applyChurch ch charg = case ch of Church chf -> chf charg
                                  ArityZero _ -> charg -- never happens!
composeChurch : Church a -> Church a -> Church a
composeChurch chl chr =
  case chl of Church chlf ->
                case chr of Church chrf -> Church <| \ f -> (chlf << chrf) f
                            otherwise -> chr -- never happens!
              otherwise -> chr -- never happens!

-- the Church Numeral functions...
churchZero : Church a
churchZero = Church <| always <| Church identity
churchOne : Church a
churchOne = Church identity
succChurch : Church a -> Church a
succChurch ch = Church <| \ f -> composeChurch f <| applyChurch ch f
addChurch : Church a -> Church a -> Church a
addChurch cha chb =
  Church <| \ f -> composeChurch (applyChurch cha f) (applyChurch chb f)
multChurch : Church a -> Church a -> Church a
multChurch cha chb = composeChurch cha chb
expChurch : Church a -> Church a -> Church a
expChurch chbs chexp = applyChurch chexp chbs
isZeroChurch : Church a -> Church a
isZeroChurch ch =
  applyChurch (applyChurch ch (Church <| \ _ -> churchZero)) churchOne
predChurch : Church a -> Church a
predChurch ch =
  Church <| \ f -> Church <| \ x ->
    let prdf = Church <| \ g -> Church <| \ h ->
                            applyChurch h (applyChurch g f)
    in applyChurch (applyChurch (applyChurch ch prdf)
                                (Church <| \ _ -> x)) <| Church identity
subChurch : Church a -> Church a -> Church a
subChurch cha chb = applyChurch (applyChurch chb <| Church predChurch) cha

divChurch : Church a -> Church a -> Church a
divChurch chdvdnd chdvsr =
  let divr n =
        let loop v = Church <| \ _ -> succChurch <| divr v
            tst v = applyChurch (applyChurch v <| loop v) churchZero
        in tst <| subChurch n chdvsr
  in divr <| succChurch chdvdnd

-- conversion functions...
intToChurch : Int -> Church a
intToChurch i = List.foldl (\ _ ch -> succChurch ch) churchZero (List.range 1 i)
churchToInt : Church Int -> Int
churchToInt ch =
  let succInt = Church <| \ ach -> case ach of ArityZero v -> ArityZero (v + 1)
                                               otherwise -> ach -- never happens!
  in case applyChurch (applyChurch ch succInt) <| ArityZero 0 of
       ArityZero r -> r
       otherwise -> -1 -- never happens!

--------------------------------------TEST--------------------------------------
main : Html.Html Never
main =
  let chThree = intToChurch 3
      chFour = succChurch chThree
      chEleven = intToChurch 11
      chTwelve = succChurch chEleven
  in [ addChurch chThree chFour
     , multChurch chThree chFour
     , expChurch chThree chFour
     , expChurch chFour chThree
     , isZeroChurch churchZero
     , isZeroChurch chThree
     , predChurch chFour
     , subChurch chEleven chThree
     , divChurch chEleven chThree
     , divChurch chTwelve chThree
     ] |> List.map (String.fromInt << churchToInt)
       |> String.join ", " |> text
