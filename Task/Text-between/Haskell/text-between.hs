import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List (intercalate)
import Data.Maybe (fromMaybe)
import Data.Text (Text, breakOn, pack, stripPrefix, unpack)

----------------------- TEXT BETWEEN ---------------------

textBetween ::
  (Either String Text, Either String Text) ->
  Text ->
  Text
textBetween (start, end) txt =
  fromMaybe
    (pack [])
    ( retain (stripPrefix <*>) snd start txt
        >>= retain (Just .) fst end
    )
  where
    retain sub part delim t =
      either
        (Just . const t)
        (sub $ part . flip breakOn t)
        delim

-------------------------- TESTS -------------------------
main :: IO ()
main = do
  mapM_ print $
    flip textBetween (head samples)
      <$> take 3 delims
  (putStrLn . unlines) $
    zipWith
      ( \d t ->
          intercalate
            (unpack $ textBetween d t)
            ["\"", "\""]
      )
      (drop 3 delims)
      (tail samples)

samples :: [Text]
samples =
  fmap
    pack
    [ "Hello Rosetta Code world",
      "</div><div style=\"chinese\">你好吗</div>",
      "<text>Hello <span>Rosetta Code</span> world"
        <> "</text><table style=\"myTable\">",
      "<table style=\"myTable\"><tr><td>"
        <> "hello world</td></tr></table>"
    ]

delims :: [(Either String Text, Either String Text)]
delims =
  fmap
    (join bimap wrap)
    [ ("Hello ", " world"),
      ("start", " world"),
      ("Hello", "end"),
      ("<div style=\"chinese\">", "</div>"),
      ("<text>", "<table>"),
      ("<text>", "</table>")
    ]

wrap :: String -> Either String Text
wrap x
  | x `elem` ["start", "end"] = Left x
  | otherwise = Right (pack x)
