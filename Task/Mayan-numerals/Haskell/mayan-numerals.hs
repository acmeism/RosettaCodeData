import Data.Bool (bool)
import Data.List (intercalate, transpose)
import qualified Data.Map.Strict as M
import Data.Maybe (maybe)

--------------------------- MAIN -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    mayanFramed
      <$> [ 4005,
            8017,
            326205,
            886205,
            1081439556,
            1000000,
            1000000000
          ]

---------------------- MAYAN NUMBERS ---------------------
mayanGlyph :: Int -> [[String]]
mayanGlyph =
  filter (any (not . null))
    . transpose
    . leftPadded
    . flip (showIntAtBaseS 20 mayanDigit) []

mayanDigit :: Int -> [String]
mayanDigit n
  | 0 /= n =
    replicate (rem n 5) mayaOne :
    concat
      ( replicate (quot n 5) [mayaFive]
      )
  | otherwise = [[mayaZero]]

mayanFramed :: Int -> String
mayanFramed =
  ("Mayan " <>)
    . ( (<>) <$> show
          <*> ( (":\n\n" <>)
                  . wikiTable
                    ( M.fromList
                        [ ( "style",
                            concat
                              [ "text-align:center;",
                                "background-color:#F0EDDE;",
                                "color:#605B4B;",
                                "border:2px solid silver;"
                              ]
                          ),
                          ("colwidth", "3em;")
                        ]
                    )
                  . mayanGlyph
              )
      )

mayaZero, mayaOne :: Char
mayaZero = '\920'
mayaOne = '\9679'

mayaFive :: String
mayaFive = "\9473\9473"

---------------------- NUMERIC BASES ---------------------
-- Based on the Prelude showIntAtBase but uses an
-- (Int -> [String]) (rather than Int -> Char) function
-- as its second argument.
--
-- Shows a /non-negative/ 'Integral' number using the base
-- specified by the first argument, and the **String**
-- representation specified by the second.
showIntAtBaseS ::
  Integral a =>
  a ->
  (Int -> [String]) ->
  a ->
  [[String]] ->
  [[String]]
showIntAtBaseS base toStr n0 r0 =
  let go (n, d) r =
        seq s $
          case n of
            0 -> r_
            _ -> go (quotRem n base) r_
        where
          s = toStr (fromIntegral d)
          r_ = s : r
   in go (quotRem n0 base) r0

------------------------- DISPLAY ------------------------
wikiTable :: M.Map String String -> [[String]] -> String
wikiTable opts rows
  | null rows = []
  | otherwise =
    "{| "
      <> foldr
        ( \k a ->
            maybe
              a
              ( ((a <> k <> "=\"") <>)
                  . ( <> "\" "
                    )
              )
              (M.lookup k opts)
        )
        []
        ["class", "style"]
      <> ( '\n' :
           intercalate
             "|-\n"
             ( zipWith renderedRow rows [0 ..]
             )
         )
      <> "|}\n\n"
  where
    renderedRow row i =
      unlines
        ( fmap
            ( ( bool
                  []
                  ( maybe
                      "|"
                      (("|style=\"width:" <>) . (<> "\""))
                      (M.lookup "colwidth" opts)
                  )
                  (0 == i)
                  <>
              )
                . ('|' :)
            )
            row
        )

leftPadded :: [[String]] -> [[String]]
leftPadded xs =
  let w = maximum (length <$> xs)
   in ((<>) =<< flip replicate [] . (-) w . length) <$> xs
