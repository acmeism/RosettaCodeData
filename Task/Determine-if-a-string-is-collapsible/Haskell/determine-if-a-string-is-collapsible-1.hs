import Text.Printf (printf)
import Data.Maybe (catMaybes)
import Control.Monad (guard)

input :: [String]
input = [ ""
        , "The better the 4-wheel drive, the further you'll be from help when ya get stuck!"
        , "headmistressship"
        , "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln "
        , "..1111111111111111111111111111111111111111111111111111111111111117777888"
        , "I never give 'em hell, I just tell the truth, and they think it's hell. "
        , "                                                    --- Harry S Truman  "
        , "😍😀🙌💃😍😍😍🙌"
        ]

collapse :: Eq a => [a] -> [a]
collapse = catMaybes . (\xs -> zipWith (\a b -> guard (a /= b) >> a) (Nothing : xs) (xs <> [Nothing])) . map Just

main :: IO ()
main =
  mapM_ (\(a, b) -> printf "old: %3d «««%s»»»\nnew: %3d «««%s»»»\n\n" (length a) a (length b) b)
  $ ((,) <*> collapse) <$> input
