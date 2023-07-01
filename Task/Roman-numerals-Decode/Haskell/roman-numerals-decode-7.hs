import qualified Data.Map.Strict as M
import Data.Maybe (maybe)

------------------ ROMAN NUMERALS DECODED ----------------

mapRoman :: M.Map Char Int
mapRoman =
  M.fromList $
    zip "IVXLCDM" $
      scanl (*) 1 (cycle [5, 2])

fromRoman :: String -> Maybe Int
fromRoman cs =
  let op l r
        | l >= r = (+)
        | otherwise = (-)
   in snd
        . foldr
          (\l (r, n) -> (l, op l r n l))
          (0, 0)
        <$> traverse (`M.lookup` mapRoman) cs

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    fTable
      "Roman numeral decoding as a right fold:\n"
      show
      (maybe "(Unrecognised character seen)" show)
      fromRoman
      [ "MDCLXVI",
        "MCMXC",
        "MMVIII",
        "MMXVI",
        "MMXVII",
        "QQXVII"
      ]

------------------------ FORMATTING ----------------------

fTable ::
  String ->
  (a -> String) ->
  (b -> String) ->
  (a -> b) ->
  [a] ->
  String
fTable s xShow fxShow f xs =
  unlines $
    s :
    fmap
      ( ((<>) . rjust w ' ' . xShow)
          <*> ((" -> " <>) . fxShow . f)
      )
      xs
  where
    rjust n c = drop . length <*> (replicate n c <>)
    w = maximum (length . xShow <$> xs)
