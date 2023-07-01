import Numeric (showHex)
import Data.List (span)
import Data.Char (ord)

inconsistentChar :: Eq a => [a] -> Maybe (Int, a)
inconsistentChar [] = Nothing
inconsistentChar xs@(x:_) =
  let (pre, post) = span (x ==) xs
  in if null post
       then Nothing
       else Just (length pre, head post)


---------------------------TEST----------------------------
samples :: [String]
samples = ["   ", "2", "333", ".55", "tttTTT", "4444 444"]

main :: IO ()
main = do
  let w = succ . maximum $ length <$> samples
      justifyRight n c = (drop . length) <*> (replicate n c ++)
      f = (++ "' -> ") . justifyRight w ' ' . ('\'' :)
  (putStrLn . unlines) $
    (\s ->
        maybe
          (f s ++ "consistent")
          (\(n, c) ->
              f s ++
              "inconsistent '" ++
              c : "' (0x" ++ showHex (ord c) ")" ++ " at char " ++ show (succ n))
          (inconsistentChar s)) <$>
    samples
