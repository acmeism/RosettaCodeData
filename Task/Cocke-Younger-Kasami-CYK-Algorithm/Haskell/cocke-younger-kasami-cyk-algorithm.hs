module Main where

import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Data.Map.Strict (Map)
import Data.Set (Set)
import Data.List (find)

type NonTerminal = String
type Terminal = String
type Symbol = String
type Rule = [Symbol]
type Grammar = Map NonTerminal [Rule]
type ParseTable = Map (Int, Int) (Set NonTerminal)

-- | CYK parser implementation. Returns True if W is valid under grammar R
cykParse :: [Terminal] -> Grammar -> Bool
cykParse w r =
    let n = length w
        t = initializeTable n
        t1 = fillTable w r n t
    in "NP" `Set.member` getCell t1 1 n

-- | Initialize the parsing table with empty sets
initializeTable :: Int -> ParseTable
initializeTable n =
    Map.fromList [((i, j), Set.empty) | i <- [1..n], j <- [1..n]]

-- | Fill the parsing table using CYK algorithm
fillTable :: [Terminal] -> Grammar -> Int -> ParseTable -> ParseTable
fillTable w r n t = fillColumns w r n 1 t

-- | Fill columns from left to right
fillColumns :: [Terminal] -> Grammar -> Int -> Int -> ParseTable -> ParseTable
fillColumns _ _ n j t | j > n = t
fillColumns w r n j t =
    let word = w !! (j - 1)
        t1 = addTerminals r word j t
        t2 = fillBackward r j j t1
    in fillColumns w r n (j + 1) t2

-- | Add terminal productions to table
addTerminals :: Grammar -> Terminal -> Int -> ParseTable -> ParseTable
addTerminals r word j t =
    Map.foldrWithKey
        (\lhs rules acc ->
            if hasTerminalRule rules word
            then addToCell acc j j lhs
            else acc
        )
        t
        r

-- | Check if rules contain a terminal production for word
hasTerminalRule :: [Rule] -> Terminal -> Bool
hasTerminalRule rules word =
    any (\rule -> length rule == 1 && head rule == word) rules

-- | Fill backward diagonally from position j
fillBackward :: Grammar -> Int -> Int -> ParseTable -> ParseTable
fillBackward _ i _ t | i < 1 = t
fillBackward r i j t =
    let t1 = fillSplits r i j i (j - 1) t
    in fillBackward r (i - 1) j t1

-- | Try all split points k from i to j-1
fillSplits :: Grammar -> Int -> Int -> Int -> Int -> ParseTable -> ParseTable
fillSplits _ _ _ k maxK t | k > maxK = t
fillSplits r i j k maxK t =
    let t1 = checkAllRules r i j k t
    in fillSplits r i j (k + 1) maxK t1

-- | Check all grammar rules for a split point
checkAllRules :: Grammar -> Int -> Int -> Int -> ParseTable -> ParseTable
checkAllRules r i j k t =
    Map.foldrWithKey
        (\lhs rules acc -> checkRules lhs rules i j k acc)
        t
        r

-- | Check individual rules
checkRules :: NonTerminal -> [Rule] -> Int -> Int -> Int -> ParseTable -> ParseTable
checkRules _ [] _ _ _ t = t
checkRules lhs (rule:rest) i j k t =
    let t1 = if length rule == 2
             then let [rhs1, rhs2] = rule
                      leftCell = getCell t i k
                      rightCell = getCell t (k + 1) j
                  in if Set.member rhs1 leftCell && Set.member rhs2 rightCell
                     then addToCell t i j lhs
                     else t
             else t
    in checkRules lhs rest i j k t1

-- | Helper functions for table manipulation
getCell :: ParseTable -> Int -> Int -> Set NonTerminal
getCell t i j = Map.findWithDefault Set.empty (i, j) t

addToCell :: ParseTable -> Int -> Int -> NonTerminal -> ParseTable
addToCell t i j element =
    let cell = getCell t i j
        newCell = Set.insert element cell
    in Map.insert (i, j) newCell t

-- | Test the CYK parser with a sample grammar and input string
main :: IO ()
main = do
    let r = Map.fromList
            [ ("NP", [["Det", "Nom"]])
            , ("Nom", [ ["AP", "Nom"]
                      , ["book"]
                      , ["orange"]
                      , ["man"]
                      ])
            , ("AP", [ ["Adv", "A"]
                     , ["heavy"]
                     , ["orange"]
                     , ["tall"]
                     ])
            , ("Det", [["a"]])
            , ("Adv", [["very"], ["extremely"]])
            , ("A", [ ["heavy"]
                    , ["orange"]
                    , ["tall"]
                    , ["muscular"]
                    ])
            ]
        w = words "a very heavy orange book"
        result = cykParse w r
    putStrLn $ "CYK Parse Result: " ++ show result
    return ()
