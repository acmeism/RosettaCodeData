import Data.Char (toLower)

type Symbol = (String, Integer)
type BinOp = (Integer -> Integer -> Integer)
type State = [Transition]

data Transition = Transition [Symbol] State BinOp
                | Illion State BinOp
                | Done

type Words = [String]
type Accumulator = Integer
type TapeValue = (Accumulator, [Symbol], Words)

ones, teens, tens, hundred, illions :: [Symbol]
ones =
    [("one", 1)
    ,("two", 2)
    ,("three", 3)
    ,("four", 4)
    ,("five", 5)
    ,("six", 6)
    ,("seven", 7)
    ,("eight", 8)
    ,("nine", 9)]

teens =
    [("ten", 10)
    ,("eleven", 11)
    ,("twelve", 12)
    ,("thirteen", 13)
    ,("fourteen", 14)
    ,("fifteen", 15)
    ,("sixteen", 16)
    ,("seventeen", 17)
    ,("eighteen", 18)
    ,("nineteen", 19)]

tens =
    [("twenty", 20)
    ,("thirty", 30)
    ,("forty", 40)
    ,("fifty", 50)
    ,("sixty", 60)
    ,("seventy", 70)
    ,("eighty", 80)
    ,("ninety", 90)]

hundred =
    [("hundred", 100)]

illions =
    [("quintillion", 10 ^ 18)
    ,("quadrillion", 10 ^ 15)
    ,("trillion", 10 ^ 12)
    ,("billion", 10 ^ 9)
    ,("million", 10 ^ 6)
    ,("thousand", 10 ^ 3)]

tokenize :: String -> Words
tokenize = words . (map replace) . (map toLower)
    where
      replace c
          | elem c ['a'..'z'] = c
          | otherwise         = ' '

lookupRest :: (Eq a) => a -> [(a,b)] -> Maybe (b, [(a,b)])
lookupRest _ [] = Nothing
lookupRest x ((y,z):ws) = if x == y
                          then Just (z, ws)
                          else lookupRest x ws

runState :: State -> TapeValue -> TapeValue
runState []     (_, _, word:_)             = error $ "Unexpected token: " ++ word
runState _      tv@(_, _, [])              = tv
runState (t:ts) tv@(int, illions, word:wx) =
    case t of
      Transition table state op ->
          case lookup word table of
            Nothing  -> runState ts tv
            Just num -> runState state (op num int, illions, wx)
      Illion state op           ->
          case lookupRest word illions of
            Nothing              -> runState ts tv
            Just (num, illions') -> runState state (op num int, illions', wx)
      Done                      -> tv

stateIllion, stateA, stateB, stateC, stateD, stateE :: State
stateIllion = [Illion [Done] (*)]

stateA = [Transition ones stateB (+)
         ,Transition tens stateD (+)
         ,Transition teens stateE (+)]

stateB = [Transition hundred stateC (*)]
         ++ stateIllion

stateC = [Transition ones stateE (+)
         ,Transition tens stateD (+)
         ,Transition teens stateE (+)]
         ++ stateIllion

stateD = [Transition ones stateE (+)]
         ++ stateIllion

stateE = stateIllion ++ [Done]

parseSubWord :: [Symbol] -> Words -> TapeValue
parseSubWord illions w = runState stateA (0, illions, w)

parse :: [Symbol] -> Words -> Integer
parse _       [] = 0
parse illions wx = let (i, illions', wx') = parseSubWord illions wx
                   in i + parse illions' wx'

integerSpell :: String -> Integer
integerSpell wx =
    case tokenize wx of
      ("negative":"zero":[]) -> -0
      ("zero":[])            -> 0
      ("negative":wx')       -> negate $ parse illions wx'
      wx'                    -> parse illions wx'
