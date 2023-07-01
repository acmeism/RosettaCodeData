import Data.List (intercalate)
import Data.Maybe (maybe)
import Safe (headMay)

maybeBabbage :: Integer -> Maybe Integer
maybeBabbage upperLimit =
  headMay
    (filter ((269696 ==) . flip rem 1000000) ((^ 2) <$> [1 .. upperLimit]))

main :: IO ()
main = do
  let upperLimit = 100000
  putStrLn $
    maybe
      (intercalate (show upperLimit) ["No such number found below ", " ..."])
      (intercalate " ^ 2  ->  " .
       fmap show . (<*>) [floor . sqrt . fromInteger, id] . pure)
      (maybeBabbage upperLimit)
