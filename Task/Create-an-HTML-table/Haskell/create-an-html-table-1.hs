import Data.List (unfoldr)
import Control.Monad (forM_)

import qualified Text.Blaze.Html5 as B
import Text.Blaze.Html.Renderer.Pretty (renderHtml)

import System.Random (RandomGen, getStdGen, randomRs, split)

makeTable
  :: RandomGen g
  => [String] -> Int -> g -> B.Html
makeTable headings nRows gen =
  B.table $
  do B.thead $ B.tr $ forM_ (B.toHtml <$> headings) B.th
     B.tbody $
       forM_
         (zip [1 .. nRows] $ unfoldr (Just . split) gen)
         (\(x, g) ->
             B.tr $
             forM_
               (take (length headings) (x : randomRs (1000, 9999) g))
               (B.td . B.toHtml))

main :: IO ()
main = do
  g <- getStdGen
  putStrLn $ renderHtml $ makeTable ["", "X", "Y", "Z"] 3 g
