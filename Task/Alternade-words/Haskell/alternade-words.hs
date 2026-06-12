import qualified Data.Set as S
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- Two words constructed from the alternating characters of a single word.
alt :: T.Text -> (T.Text, T.Text)
alt = T.foldl' (\(l, r) c -> (r `T.snoc` c, l)) (T.empty, T.empty)

-- The alternades of a list of words.
alternades :: S.Set T.Text -> [T.Text] -> [(T.Text, (T.Text, T.Text))]
alternades dict ws = filter (areMembers . snd) $ zip ws $ map alt ws
  where areMembers (x, y) = S.member x dict && S.member y dict

main :: IO ()
main = TIO.interact $ \txt ->
  let words' = map T.toLower $ T.lines txt
      dict   = S.fromList words'
  in T.unlines $ map alterShow $ alternades dict $ filter longEnough words'
  where longEnough = (>= 6) . T.length
        alterShow (w, (x, y)) = T.unwords [w, x, y]
