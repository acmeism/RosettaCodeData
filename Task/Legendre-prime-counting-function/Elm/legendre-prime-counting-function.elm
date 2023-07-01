module Main exposing (main)

import Browser exposing (element)
import Task exposing (Task, succeed, perform, andThen)
import Html exposing (div, text)
import Time exposing (now, posixToMillis)

type CIS a = CIS a (() -> CIS a) -- infinite Co-Inductive Stream...

uptoCIS2List : comparable -> CIS comparable -> List comparable
uptoCIS2List n cis =
  let loop (CIS hd tl) lst =
        if hd > n then List.reverse lst
        else loop (tl()) (hd :: lst)
  in loop cis []

-- require a range of primes by Sieve of Eratosthenes...
primesTreeFolding : () -> CIS Int
primesTreeFolding() =
  let
    merge (CIS x xtl as xs) (CIS y ytl as ys) =
      case compare x y of
        LT -> CIS x <| \ () -> merge (xtl()) ys
        EQ -> CIS x <| \ () -> merge (xtl()) (ytl())
        GT -> CIS y <| \ () -> merge xs (ytl())
    pmult bp =
      let adv = bp + bp
          pmlt p = CIS p <| \ () -> pmlt (p + adv)
      in pmlt (bp * bp)
    allmlts (CIS bp bptl) =
      CIS (pmult bp) <| \ () -> allmlts (bptl())
    pairs (CIS frst tls) =
      let (CIS scnd tlss) = tls()
      in CIS (merge frst scnd) <| \ () -> pairs (tlss())
    cmpsts (CIS (CIS hd tl) tls) =
      CIS hd <| \ () -> merge (tl()) <| cmpsts <| pairs (tls())
    testprm n (CIS hd tl as cs) =
      if n < hd then CIS n <| \ () -> testprm (n + 2) cs
      else testprm (n + 2) (tl())
    oddprms() =
      CIS 3 <| \ () -> testprm 5 <| cmpsts <| allmlts <| oddprms()
  in CIS 2 <| \ () -> oddprms()

countPrimesTo : Float -> Float -- only use integral values!
countPrimesTo n =
  if n < 3 then if n < 2 then 0 else 1 else
  let nnf = toFloat (floor n) -- erase fractional part!
      sqrtn = sqrt nnf |> truncate
      oprms = primesTreeFolding() |> uptoCIS2List sqrtn |> List.drop 1
      opsz = List.length oprms
      lvl opi opilmt plst m acc =
        if opi >= opilmt then acc else
        case plst of
          [] -> acc -- should never happen
          (op :: optl) ->
            let opl = toFloat op
                nm = m * opl in
            if nnf <= nm * opl then acc + toFloat (opilmt - opi) else
            let q = nnf / nm |> floor |> toFloat
                nacc = acc + q - toFloat (floor (q / 2))
                sacc = if opi <= 0 then 0 else lvl 0 opi oprms nm 0
            in lvl (opi + 1) opilmt optl m (nacc - sacc)
  in nnf - toFloat (floor (nnf / 2)) - lvl 0 opsz oprms 1 0 + toFloat opsz

-- run the required task tests...
timemillis : () -> Task Never Int -- a side effect function
timemillis() = now |> andThen (\ t -> succeed (posixToMillis t))

test : () -> Cmd Msg -- side effect function chain (includes "perform")...
test() =
  timemillis()
    |> andThen (\ strt ->
       let rsltstrs = List.range 0 9 |> List.map ( \ n ->
                        "π(10^" ++ String.fromInt n ++ ") = " ++
                          String.fromFloat (countPrimesTo (toFloat (10^n))))
       in timemillis()
         |> andThen (\ stop ->
              succeed (List.append rsltstrs ["This took "
                         ++ String.fromInt (stop - strt)
                         ++ " milliseconds."])))
    |> perform Done

-- following code has to do with outputting to a web page using MUV/TEA...
type alias Model = List String

type Msg = Done Model

main : Program () Model Msg
main = -- starts with empty list of strings; views model of filled list...
  element { init = \ _ -> ( [], test() )
          , update = \ (Done mdl) _ -> ( mdl , Cmd.none )
          , subscriptions = \ _ -> Sub.none
          , view = div [] << List.map (div [] << List.singleton << text) }
