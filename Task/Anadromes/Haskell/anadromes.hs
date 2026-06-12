import qualified Data.Set as S
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- The anadromes of a list of words.  We convert all words to lower case.
anadromes :: [T.Text] -> [(T.Text, T.Text)]
anadromes ws = let set = S.fromList $ map T.toLower ws
               in S.foldr (step set) [] set
  where step set w ps = let rev = T.reverse w
                        in if w < rev && S.member rev set
                           then (w, rev) : ps
                           else ps

main :: IO ()
main = TIO.interact (T.unlines . map anaShow . anadromes . longEnough . T.lines)
  where longEnough = filter ((> 6) . T.length)
        anaShow (x, y) = T.unwords [x, y]
