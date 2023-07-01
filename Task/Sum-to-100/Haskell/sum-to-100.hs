import Control.Monad (replicateM)
import Data.Char (intToDigit)
import Data.List
  ( find,
    group,
    intercalate,
    nub,
    sort,
    sortBy,
  )
import Data.Monoid ((<>))
import Data.Ord (comparing)

data Sign
  = Unsigned
  | Plus
  | Minus
  deriving (Eq, Show)

------------------------ SUM TO 100 ----------------------

universe :: [[(Int, Sign)]]
universe =
  zip [1 .. 9]
    <$> filter
      ((/= Plus) . head)
      (replicateM 9 [Unsigned, Plus, Minus])

allNonNegativeSums :: [Int]
allNonNegativeSums =
  sort $
    filter
      (>= 0)
      (asSum <$> universe)

uniqueNonNegativeSums :: [Int]
uniqueNonNegativeSums = nub allNonNegativeSums

asSum :: [(Int, Sign)] -> Int
asSum xs =
  n
    + ( case s of
          [] -> 0
          _ -> read s :: Int
      )
  where
    (n, s) = foldr readSign (0, []) xs
    readSign ::
      (Int, Sign) ->
      (Int, String) ->
      (Int, String)
    readSign (i, x) (n, s)
      | x == Unsigned = (n, intToDigit i : s)
      | otherwise =
        ( ( case x of
              Plus -> (+)
              _ -> (-)
          )
            n
            (read (show i <> s) :: Int),
          []
        )

asString :: [(Int, Sign)] -> String
asString = foldr signedDigit []
  where
    signedDigit (i, x) s
      | x == Unsigned = intToDigit i : s
      | otherwise =
        ( case x of
            Plus -> " +"
            _ -> " -"
        )
          <> [intToDigit i]
          <> s

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    unlines
      [ "Sums to 100:",
        unlines
          (asString <$> filter ((100 ==) . asSum) universe),
        "\n10 commonest sums (sum, number of routes to it):",
        show
          ( ((,) <$> head <*> length)
              <$> take
                10
                ( sortBy
                    (flip (comparing length))
                    (group allNonNegativeSums)
                )
          ),
        "\nFirst positive integer not expressible "
          <> "as a sum of this kind:",
        maybeReport
          ( find
              (uncurry (/=))
              (zip [0 ..] uniqueNonNegativeSums)
          ),
        "\n10 largest sums:",
        show
          ( take
              10
              ( sortBy
                  (flip compare)
                  uniqueNonNegativeSums
              )
          )
      ]
  where
    maybeReport ::
      Show a =>
      Maybe (a, b) ->
      String
    maybeReport (Just (x, _)) = show x
    maybeReport _ = "No gaps found"
