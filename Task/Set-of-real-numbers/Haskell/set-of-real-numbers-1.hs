{- Not so functional representation of R sets (with IEEE Double), in a strange way -}

import Data.List
import Data.Maybe

data BracketType = OpenSub | ClosedSub
    deriving (Show, Enum, Eq, Ord)

data RealInterval = RealInterval {left :: BracketType, right :: BracketType,
    lowerBound :: Double, upperBound :: Double}
    deriving (Eq)

type RealSet = [RealInterval]
posInf = 1.0/0.0 :: Double -- IEEE tricks
negInf = (-1.0/0.0) :: Double
set_R = RealInterval ClosedSub ClosedSub negInf posInf :: RealInterval

emptySet = [] :: [RealInterval]

instance Show RealInterval where
    show x@(RealInterval _ _ y y')
        | y == y' && (left x == right x) && (left x == ClosedSub) = "{" ++ (show y) ++ "}"
        | otherwise = [['(', '[']!!(fromEnum $ left x)] ++ (show $ lowerBound x) ++
         "," ++ (show $ upperBound x) ++ [[')', ']']!!(fromEnum $ right x)]
    showList [x] = shows x
    showList (h:t) = shows h . (" U " ++) . showList t
    showList [] =  (++ "(/)") -- empty set

construct_interval :: Char -> Double -> Double -> Char -> RealInterval
construct_interval '(' x y ')' = RealInterval OpenSub OpenSub x y
construct_interval '(' x y ']' = RealInterval OpenSub ClosedSub x y
construct_interval '[' x y ')' = RealInterval ClosedSub OpenSub x y
construct_interval _ x y _ = RealInterval ClosedSub ClosedSub x y

set_is_empty :: RealSet -> Bool
set_is_empty rs = (rs == emptySet)

set_in :: Double -> RealSet -> Bool
set_in x [] = False
set_in x rs =
    isJust (find (\s ->
        ((lowerBound s < x) && (x < upperBound s)) ||
        (x == lowerBound s && left s == ClosedSub) ||
        (x == upperBound s && right s == ClosedSub))
        rs)

-- max, min for pairs (double, bracket)
max_p :: (Double, BracketType) -> (Double, BracketType) -> (Double, BracketType)
min_p :: (Double, BracketType) -> (Double, BracketType) -> (Double, BracketType)
max_p p1@(x, y) p2@(x', y')
    | x == x' = (x, max y y') -- closed is stronger than open
    | x < x'  = p2
    | otherwise = p1

min_p p1@(x, y) p2@(x', y')
    | x == x' = (x, min y y')
    | x < x'  = p1
    | otherwise = p2

simple_intersection :: RealInterval -> RealInterval -> [RealInterval]
simple_intersection ri1@(RealInterval l_ri1 r_ri1 x1 y1) ri2@(RealInterval l_ri2 r_ri2 x2 y2)
    | (y1 < x2) || (y2 < x1) = emptySet
    | (y1 == x2) && ((fromEnum r_ri1) + (fromEnum l_ri2) /= 2) = emptySet
    | (y2 == x1) && ((fromEnum r_ri2) + (fromEnum l_ri1) /= 2) = emptySet
    | otherwise = let lb = if x1 == x2 then (x1, min l_ri1 l_ri2) else max_p (x1, l_ri1) (x2, l_ri2) in
        let rb = min_p (y1, right ri1) (y2, right ri2) in
            [RealInterval (snd lb) (snd rb) (fst lb) (fst rb)]

simple_union :: RealInterval -> RealInterval -> [RealInterval]
simple_union ri1@(RealInterval l_ri1 r_ri1 x1 y1) ri2@(RealInterval l_ri2 r_ri2 x2 y2)
    | (y1 < x2) || (y2 < x1) = [ri2, ri1]
    | (y1 == x2) && ((fromEnum r_ri1) + (fromEnum l_ri2) /= 2) = [ri1, ri2]
    | (y2 == x1) && ((fromEnum r_ri2) + (fromEnum l_ri1) /= 2) = [ri1, ri2]
    | otherwise = let lb = if x1 == x2 then (x1, max l_ri1 l_ri2) else min_p (x1, l_ri1) (x2, l_ri2) in
        let rb = max_p (y1, right ri1) (y2, right ri2) in
            [RealInterval (snd lb) (snd rb) (fst lb) (fst rb)]

simple_complement :: RealInterval -> [RealInterval]
simple_complement ri1@(RealInterval l_ri1 r_ri1 x1 y1) =
    [(RealInterval ClosedSub (inv l_ri1) negInf x1), (RealInterval (inv r_ri1) ClosedSub y1 posInf)]
    where
        inv OpenSub = ClosedSub
        inv ClosedSub = OpenSub

set_sort :: RealSet -> RealSet
set_sort rs =
    sortBy
        (\s1 s2 ->
            let (lp, rp) = ((lowerBound s1, left s1), (lowerBound s2, left s2)) in
                if max_p lp rp == lp then GT else LT)
        rs

set_simplify :: RealSet -> RealSet
set_simplify [] = emptySet
set_simplify rs =
    concat (map make_empty (set_sort (foldl
        (\acc ri1 -> (simple_union (head acc) ri1) ++ (tail acc))
        [head sorted_rs]
        sorted_rs)))
    where
        sorted_rs = set_sort rs
        make_empty ri@(RealInterval lb rb x y)
            | x >= y && (lb /= rb || rb /= ClosedSub) = emptySet
            | otherwise = [ri]

-- set operations
set_complement :: RealSet -> RealSet
set_union :: RealSet -> RealSet -> RealSet
set_intersection :: RealSet -> RealSet -> RealSet
set_difference :: RealSet -> RealSet -> RealSet
set_measure :: RealSet -> Double

set_complement rs =
    foldl set_intersection [set_R] (map simple_complement rs)
set_union rs1 rs2 =
    set_simplify (rs1 ++ rs2)
set_intersection rs1 rs2 =
    set_simplify $ concat [simple_intersection s1 s2 | s1 <- rs1, s2 <- rs2]
set_difference rs1 rs2 =
    set_intersection (set_complement rs2) rs1
set_measure rs =
    foldl (\acc x -> acc + (upperBound x) - (lowerBound x)) 0.0 rs

-- test
test = map (\x -> [x]) [construct_interval '(' 0 1 ']', construct_interval '[' 0 2 ')',
    construct_interval '[' 0 2 ')', construct_interval '(' 1 2 ']',
    construct_interval '[' 0 3 ')', construct_interval '(' 0 1 ')',
    construct_interval '[' 0 3 ')', construct_interval '[' 0 1 ']']
restest = [set_union (test!!0) (test!!1), set_intersection (test!!2) (test!!3),
    set_difference (test!!4) (test!!5), set_difference (test!!6) (test!!7)]
isintest s =
    mapM_
        (\x -> putStrLn ((show x) ++ " is in " ++ (show s) ++ " : " ++ (show (set_in x s))))
        [0, 1, 2]

testA = [construct_interval '(' (sqrt (n + (1.0/6))) (sqrt (n + (5.0/6))) ')' | n <- [0..99]]
testB = [construct_interval '(' (n + (1.0/6)) (n + (5.0/6)) ')' | n <- [0..9]]

main =
    putStrLn ("union " ++ (show (test!!0)) ++ " " ++ (show (test!!1)) ++ " = " ++ (show (restest!!0))) >>
    putStrLn ("inter " ++ (show (test!!2)) ++ " " ++ (show (test!!3)) ++ " = " ++ (show (restest!!1))) >>
    putStrLn ("diff " ++ (show (test!!4)) ++ " " ++ (show (test!!5)) ++ " = " ++ (show (restest!!2))) >>
    putStrLn ("diff " ++ (show (test!!6)) ++ " " ++ (show (test!!7)) ++ " = " ++ (show (restest!!3))) >>
    mapM_ isintest restest >>
    putStrLn ("measure: " ++ (show (set_measure (set_difference testA testB))))
