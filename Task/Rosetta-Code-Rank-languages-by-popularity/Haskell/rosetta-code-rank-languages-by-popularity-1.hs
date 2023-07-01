{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson
import Network.HTTP.Base (urlEncode)
import Network.HTTP.Conduit (simpleHttp)
import Data.List (sortBy, groupBy)
import Data.Function (on)
import Data.Map (Map, toList)

-- Record representing a single language.
data Language =
    Language {
        name      :: String,
        quantity  :: Int
    } deriving (Show)

-- Make Language an instance of FromJSON for parsing of query response.
instance FromJSON Language where
    parseJSON (Object p) = do
        categoryInfo <- p .:? "categoryinfo"

        let quantity = case categoryInfo of
                           Just ob -> ob .: "size"
                           Nothing -> return 0

            name = p .: "title"

        Language <$> name <*> quantity

-- Record representing entire response to query.
-- Contains collection of languages and optional continuation string.
data Report =
    Report {
        continue    :: Maybe String,
        languages   :: Map String Language
    } deriving (Show)

-- Make Report an instance of FromJSON for parsing of query response.
instance FromJSON Report where
    parseJSON (Object p) = do
        querycontinue <- p .:? "query-continue"

        let continue
                = case querycontinue of
                      Just ob -> fmap Just $
                                     (ob .: "categorymembers") >>=
                                     (   .: "gcmcontinue")
                      Nothing -> return Nothing

            languages = (p .: "query") >>= (.: "pages")

        Report <$> continue <*> languages

-- Pretty print a single language
showLanguage :: Int -> Bool -> Language -> IO ()
showLanguage rank tie (Language languageName languageQuantity) =
    let rankStr = show rank
    in putStrLn $ rankStr ++ "." ++
                      replicate (4 - length rankStr) ' ' ++
                      (if tie then " (tie)" else "      ") ++
                      " " ++ drop 9 languageName ++
                      " - " ++ show languageQuantity

-- Pretty print languages with common rank
showRanking :: (Int,  [Language]) -> IO ()
showRanking (ranking, languages) =
    mapM_ (showLanguage ranking $ length languages > 1) languages

-- Sort and group languages by rank, then pretty print them.
showLanguages :: [Language] -> IO ()
showLanguages allLanguages =
    mapM_ showRanking $
          zip [1..] $
          groupBy ((==) `on` quantity) $
          sortBy (flip compare `on` quantity) allLanguages

-- Mediawiki api style query to send to rosettacode.org
queryStr = "http://rosettacode.org/mw/api.php?" ++
           "format=json" ++
           "&action=query" ++
           "&generator=categorymembers" ++
           "&gcmtitle=Category:Programming%20Languages" ++
           "&gcmlimit=100" ++
           "&prop=categoryinfo"

-- Issue query to get a list of Language descriptions
runQuery :: [Language] -> String -> IO ()
runQuery ls query = do
    Just (Report continue langs) <- decode <$> simpleHttp query
    let accLanguages = ls ++ map snd (toList langs)

    case continue of
        -- If there is no continue string we are done so display the accumulated languages.
        Nothing -> showLanguages accLanguages

        -- If there is a continue string, recursively continue the query.
        Just continueStr -> do
            let continueQueryStr = queryStr ++ "&gcmcontinue=" ++ urlEncode continueStr
            runQuery accLanguages continueQueryStr

main :: IO ()
main = runQuery [] queryStr
