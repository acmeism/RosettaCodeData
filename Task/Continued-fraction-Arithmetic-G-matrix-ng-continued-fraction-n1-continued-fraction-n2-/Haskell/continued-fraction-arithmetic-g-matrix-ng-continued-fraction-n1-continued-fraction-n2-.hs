----------------------------------------------------------------------

data Term = InfiniteTerm | IntegerTerm Integer
type ContinuedFraction = [Term] -- The list should be infinitely long.

type NG8 = (Integer, Integer, Integer, Integer,
            Integer, Integer, Integer, Integer)

----------------------------------------------------------------------

cf2string (cf :: ContinuedFraction) =
  loop 0 "[" cf
  where loop i s lst =
          case lst of {
            (InfiniteTerm : _) -> s ++ "]" ;
            (IntegerTerm value : tail) ->
              (if i == 20 then
                 s ++ ",...]"
               else
                 let {
                   sepStr =
                       case i of {
                         0 -> "";
                         1 -> ";";
                         _ -> ","
                         };
                   termStr = show value;
                   s1 = s ++ sepStr ++ termStr
                   }
                 in loop (i + 1) s1 tail)
            }

----------------------------------------------------------------------

repeatingTerm (term :: Term) =
  term : repeatingTerm term

infiniteContinuedFraction = repeatingTerm InfiniteTerm

i2cf (i :: Integer) =
  -- Continued fraction representing an integer.
  IntegerTerm i : infiniteContinuedFraction

r2cf (n :: Integer) (d :: Integer) =
  -- Continued fraction representing a rational number.
  let (q, r) = divMod n d in
    (if r == 0 then
        (IntegerTerm q : infiniteContinuedFraction)
     else
        (IntegerTerm q : r2cf d r))

----------------------------------------------------------------------

add_cf = apply_ng8 (0, 1, 1, 0, 0, 0, 0, 1)
sub_cf = apply_ng8 (0, 1, -1, 0, 0, 0, 0, 1)
mul_cf = apply_ng8 (1, 0, 0, 0, 0, 0, 0, 1)
div_cf = apply_ng8 (0, 1, 0, 0, 0, 0, 1, 0)

apply_ng8
  (ng :: NG8)
  (x :: ContinuedFraction)
  (y :: ContinuedFraction) =
  --
  let (a12, a1, a2, a, b12, b1, b2, b) = ng in
    if iseqz [b12, b1, b2, b] then
      infiniteContinuedFraction -- No more finite terms to output.
    else if iseqz [b2, b] then
      let (ng1, x1, y1) = absorb_x_term ng x y in
        apply_ng8 ng1 x1 y1
    else if atLeastOne_iseqz [b2, b] then
      let (ng1, x1, y1) = absorb_y_term ng x y in
        apply_ng8 ng1 x1 y1
    else if iseqz [b1] then
      let (ng1, x1, y1) = absorb_x_term ng x y in
        apply_ng8 ng1 x1 y1
    else
      let {
        (q12, r12) = maybeDivide a12 b12;
        (q1, r1) = maybeDivide a1 b1;
        (q2, r2) = maybeDivide a2 b2;
        (q, r) = maybeDivide a b
        }
      in
        if not (iseqz [b12]) && q == q12 && q == q1 && q == q2 then
          -- Output a term.
          (if integerExceedsInfinitizingThreshold q then
             infiniteContinuedFraction
           else
             let new_ng = (b12, b1, b2, b, r12, r1, r2, r) in
               (IntegerTerm q : apply_ng8 new_ng x y))
        else
          -- Put a1, a2, and a over a common denominator and compare
          -- some magnitudes.
          let {
            n1 = a1 * b2 * b;
            n2 = a2 * b1 * b;
            n = a * b1 * b2
            }
          in
            (if abs (n1 - n) > abs (n2 - n) then
               let (ng1, x1, y1) = absorb_x_term ng x y in
                 apply_ng8 ng1 x1 y1
             else
               let (ng1, x1, y1) = absorb_y_term ng x y in
                 apply_ng8 ng1 x1 y1)

absorb_x_term
  ((a12, a1, a2, a, b12, b1, b2, b) :: NG8)
  (x :: ContinuedFraction)
  (y :: ContinuedFraction) =
  --
  case x of {
    (IntegerTerm n : xtail) -> (
        let new_ng = (a2 + (a12 * n), a + (a1 * n), a12, a1,
                      b2 + (b12 * n), b + (b1 * n), b12, b1) in
          if (ng8ExceedsProcessingThreshold new_ng) then
            -- Pretend we have reached an infinite term.
            ((a12, a1, a12, a1, b12, b1, b12, b1),
             infiniteContinuedFraction, y)
          else
            (new_ng, xtail, y)
        );
    (InfiniteTerm : _) ->
        ((a12, a1, a12, a1, b12, b1, b12, b1),
          infiniteContinuedFraction, y)
    }

absorb_y_term
  ((a12, a1, a2, a, b12, b1, b2, b) :: NG8)
  (x :: ContinuedFraction)
  (y :: ContinuedFraction) =
  --
  case y of {
    (IntegerTerm n : ytail) -> (
        let new_ng = (a1 + (a12 * n), a12, a + (a2 * n), a2,
                      b1 + (b12 * n), b12, b + (b2 * n), b2) in
          if (ng8ExceedsProcessingThreshold new_ng) then
            -- Pretend we have reached an infinite term.
            ((a12, a12, a2, a2, b12, b12, b2, b2),
             x, infiniteContinuedFraction)
          else
            (new_ng, x, ytail)
        );
    (InfiniteTerm : _) ->
        ((a12, a12, a2, a2, b12, b12, b2, b2),
          x, infiniteContinuedFraction)
    }

ng8ExceedsProcessingThreshold (a12, a1, a2, a,
                               b12, b1, b2, b) =
  (integerExceedsProcessingThreshold a12 ||
   integerExceedsProcessingThreshold a1  ||
   integerExceedsProcessingThreshold a2  ||
   integerExceedsProcessingThreshold a   ||
   integerExceedsProcessingThreshold b12 ||
   integerExceedsProcessingThreshold b1  ||
   integerExceedsProcessingThreshold b2  ||
   integerExceedsProcessingThreshold b)

integerExceedsProcessingThreshold i =
  abs i >= 2 ^ 512

integerExceedsInfinitizingThreshold i =
  abs i >= 2 ^ 64

maybeDivide a b =
  if b == 0
  then (0, 0)
  else divMod a b

iseqz [] = True
iseqz (head : tail) = head == 0 && iseqz tail

atLeastOne_iseqz [] = False
atLeastOne_iseqz (head : tail) = head == 0 || atLeastOne_iseqz tail

----------------------------------------------------------------------

zero = i2cf 0
one = i2cf 1
two = i2cf 2
three = i2cf 3
four = i2cf 4

one_fourth = r2cf 1 4
one_third = r2cf 1 3
one_half = r2cf 1 2
two_thirds = r2cf 2 3
three_fourths = r2cf 3 4

goldenRatio = repeatingTerm (IntegerTerm 1)
silverRatio = repeatingTerm (IntegerTerm 2)

sqrt2 = IntegerTerm 1 : silverRatio
sqrt5 = IntegerTerm 2 : repeatingTerm (IntegerTerm 4)

----------------------------------------------------------------------

padLeft n s
  | length s < n = replicate (n - length s) ' ' ++ s
  | otherwise = s

padRight n s
  | length s < n = s ++ replicate (n - length s) ' '
  | otherwise = s

show_cf (expression, cf, note) =
  let exprStr = padLeft 19 expression in
    do { putStr exprStr;
         putStr " =>  ";
         if note == "" then
           putStrLn (cf2string cf)
         else
           let cfStr = padRight 48 (cf2string cf) in
             do { putStr cfStr;
                  putStrLn note }
       }

thirteen_elevenths = r2cf 13 11
twentytwo_sevenths = r2cf 22 7

main = do {
  show_cf ("golden ratio", goldenRatio, "(1 + sqrt(5))/2");
  show_cf ("silver ratio", silverRatio, "(1 + sqrt(2))");
  show_cf ("sqrt(2)", sqrt2, "from the module");
  show_cf ("sqrt(2)", silverRatio `sub_cf` one,
           "from the silver ratio");
  show_cf ("sqrt(5)", sqrt5, "from the module");
  show_cf ("sqrt(5)", (two `mul_cf` goldenRatio) `sub_cf` one,
            "from the golden ratio");
  show_cf ("13/11", thirteen_elevenths, "");
  show_cf ("22/7", twentytwo_sevenths, "approximately pi");
  show_cf ("13/11 + 1/2", thirteen_elevenths `add_cf` one_half, "");
  show_cf ("22/7 + 1/2", twentytwo_sevenths `add_cf` one_half, "");
  show_cf ("(22/7) * 1/2", twentytwo_sevenths `mul_cf` one_half, "");
  show_cf ("(22/7) / 2", twentytwo_sevenths `div_cf` two, "");
  show_cf ("sqrt(2) + sqrt(2)", sqrt2 `add_cf` sqrt2, "");
  show_cf ("sqrt(2) - sqrt(2)", sqrt2 `sub_cf` sqrt2, "");
  show_cf ("sqrt(2) * sqrt(2)", sqrt2 `mul_cf` sqrt2, "");
  show_cf ("sqrt(2) / sqrt(2)", sqrt2 `div_cf` sqrt2, "");
  return ()
  }

----------------------------------------------------------------------
