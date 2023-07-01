-- A continued fraction is represented as a lazy list of Int.

-- We borrow real2cf from
-- https://rosettacode.org/wiki/Continued_fraction/Arithmetic/Construct_from_rational_number#Haskell
-- though here some names in it are changed.

import Data.Ratio ((%))

real2cf frac =
  let (quotient, remainder) = properFraction frac
  in (quotient : (if remainder == 0
                  then []
                  else real2cf (1 / remainder)))

apply_hfunc (a1, a, b1, b) cf =
  recurs (a1, a, b1, b, cf)
  where recurs (a1, a, b1, b, cf) =
          if b1 == 0 && b == 0 then
            []
          else if b1 /= 0 && b /= 0 then
            let q1 = div a1 b1
                q = div a b
            in
              if q1 == q then
                q : recurs (b1, b, a1 - (b1 * q), a - (b * q), cf)
              else
                recurs (take_term (a1, a, b1, b, cf))
          else recurs (take_term (a1, a, b1, b, cf))
          where take_term (a1, a, b1, b, cf) =
                  case cf of
                    [] -> (a1, a1, b1, b1, cf)
                    (term : cf1) -> (a + (a1 * term), a1,
                                     b + (b1 * term), b1,
                                     cf1)

cf_13_11 = real2cf (13 % 11)
cf_22_7 = real2cf (22 % 7)
cf_sqrt2 = real2cf (sqrt 2)

cfToString cf =
  loop 0 0 "[" cf
  where loop i sep s lst =
          case lst of
            [] -> s ++ "]"
            (term : tail) ->
              if i == 20
              then s ++ ",...]"
              else
                do loop (i + 1) sep1 s1 tail
                     where sepStr = case sep of
                                      0 -> ""
                                      1 -> ";"
                                      _ -> ","
                           sep1 = min (sep + 1) 2
                           termStr = show term
                           s1 = s ++ sepStr ++ termStr

show_cf expr cf =
  do putStr expr;
     putStr " => ";
     putStrLn (cfToString cf)

main =
  do show_cf "13/11" cf_13_11;
     show_cf "22/7" cf_22_7;
     show_cf "sqrt(2)" cf_sqrt2;
     show_cf "13/11 + 1/2" (apply_hfunc (2, 1, 0, 2) cf_13_11);
     show_cf "22/7 + 1/2" (apply_hfunc (2, 1, 0, 2) cf_22_7);
     show_cf "(22/7)/4" (apply_hfunc (1, 0, 0, 4) cf_22_7);
     show_cf "1/sqrt(2)" (apply_hfunc (0, 1, 1, 0) cf_sqrt2);
     show_cf "(2 + sqrt(2))/4" (apply_hfunc (1, 2, 0, 4) cf_sqrt2);
     show_cf "(1 + 1/sqrt(2))/2" (apply_hfunc (2, 1, 0, 2) -- cf + 1/2
                                  (apply_hfunc (1, 0, 0, 2)  -- cf/2
                                   (apply_hfunc (0, 1, 1, 0) -- 1/cf
                                     cf_sqrt2)))
