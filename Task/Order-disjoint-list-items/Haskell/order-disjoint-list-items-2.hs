import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (delete, transpose)
import Data.Text hiding
  ( concat,
    foldl,
    maximum,
    transpose,
    zipWith,
  )
import Prelude hiding (length, unlines, unwords, words)

disjointOrder ::
  Eq a =>
  [a] ->
  [a] ->
  [a]
disjointOrder m n = concat $ zipWith (<>) ms ns
  where
    ms = segments m n
    -- As a list of lists, lengthened by 1
    ns = ((: []) <$> n) <> [[]]
    segments ::
      Eq a =>
      [a] ->
      [a] ->
      [[a]]
    segments m n = _m <> [_acc]
      where
        (_m, _, _acc) = foldl split ([], n, []) m
        split ::
          Eq a =>
          ([[a]], [a], [a]) ->
          a ->
          ([[a]], [a], [a])
        split (ms, ns, acc) x
          | x `elem` ns = (ms <> [acc], delete x ns, [])
          | otherwise = (ms, ns, acc <> [x])

--------------------------- TEST -------------------------
tests :: [(Text, Text)]
tests =
  join bimap pack
    <$> [ ("the cat sat on the mat", "mat cat"),
          ("the cat sat on the mat", "cat mat"),
          ("A B C A B C A B C", "C A C A"),
          ("A B C A B D A B E", "E A D A"),
          ("A B", "B"),
          ("A B", "B A"),
          ("A B B A", "B A")
        ]

table :: Text -> [[Text]] -> Text
table delim rows =
  unlines $
    intercalate delim
      <$> transpose
        ( ( \col ->
              let width = (length $ maximum col)
               in justifyLeft width ' ' <$> col
          )
            <$> transpose rows
        )

main :: IO ()
main =
  (putStr . unpack) $
    table (pack "  ->  ") $
      ( \(m, n) ->
          [ m,
            n,
            unwords (disjointOrder (words m) (words n))
          ]
      )
        <$> tests
