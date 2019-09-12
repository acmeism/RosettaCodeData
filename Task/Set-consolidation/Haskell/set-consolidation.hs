import Data.List (intersperse, intercalate)
import qualified Data.Set as S

consolidate
  :: Ord a
  => [S.Set a] -> [S.Set a]
consolidate = foldr comb []
  where
    comb s_ [] = [s_]
    comb s_ (s:ss)
      | S.null (s `S.intersection` s_) = s : comb s_ ss
      | otherwise = comb (s `S.union` s_) ss

-- TESTS -------------------------------------------------
main :: IO ()
main =
  (putStrLn . unlines)
    ((intercalate ", and " . fmap showSet . consolidate) . fmap S.fromList <$>
     [ ["ab", "cd"]
     , ["ab", "bd"]
     , ["ab", "cd", "db"]
     , ["hik", "ab", "cd", "db", "fgh"]
     ])

showSet :: S.Set Char -> String
showSet = flip intercalate ["{", "}"] . intersperse ',' . S.elems
