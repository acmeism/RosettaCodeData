import Network.HTTP
import Text.Parsec

data YahooSearchItem = YahooSearchItem {
    itemUrl, itemTitle, itemContent :: String }

data YahooSearch = YahooSearch {
    searchQuery :: String,
    searchPage :: Int,
    searchItems :: [YahooSearchItem] }

-- URL for Yahoo! searches, without giving a page number
yahooUrl = "http://search.yahoo.com/search?p="

-- make an HTTP request and return a YahooSearch
yahoo :: String -> IO YahooSearch
yahoo q = simpleHTTP (getRequest $ yahooUrl ++ q) >>=
    getResponseBody >>= return . YahooSearch q 1 . items

-- get some results and return the next page of results
next :: YahooSearch -> IO YahooSearch
next (YahooSearch q p _) =
    simpleHTTP (getRequest $
    -- add the page number to the search
    yahooUrl ++ q ++ "&b=" ++ show (p + 1)) >>=
    getResponseBody >>= return . YahooSearch q (p + 1) . items

printResults :: YahooSearch -> IO ()
printResults (YahooSearch q p items) = do
    putStrLn $ "Showing Yahoo! search results for query: " ++ q
    putStrLn $ "Page: " ++ show p
    putChar '\n'
    mapM_ printOne items
    where
        printOne (YahooSearchItem itemUrl itemTitle itemContent) = do
            putStrLn $ "URL   : " ++ itemUrl
            putStrLn $ "Title : " ++ itemTitle
            putStrLn $ "Abstr : " ++ itemContent
            putChar '\n'

urlTag, titleTag, contentTag1, contentTag2, ignoreTag,
    ignoreText :: Parsec String () String

-- parse a tag containing the URL of a search result
urlTag = do { string "<a id=\"link-";
    many digit; string "\" class=\"yschttl spt\" href=\"";
    url <- manyTill anyChar (char '"'); manyTill anyChar (char '>');
    return url }

-- the title comes after the URL tag, so parse it first, discard it
-- and get the title text
titleTag = do { urlTag; manyTill anyChar (try (string "</a>")) }

-- parse a tag containing the description of the search result
-- the tag can be named "sm-abs" or "abstr"
contentTag1 = do { string "<div class=\"sm-abs\">";
    manyTill anyChar (try (string "</div>")) }

contentTag2 = do { string "<div class=\"abstr\">";
    manyTill anyChar (try (string "</div>")) }

-- parse a tag and discard it
ignoreTag = do { char ('<'); manyTill anyChar (char '>');
    return "" }

-- parse some text and discard it
ignoreText = do { many1 (noneOf "<"); return "" }

-- return only non-empty strings
nonempty :: [String] -> Parsec String () [String]
nonempty xs = return [ x | x <- xs, not (null x) ]

-- a template to parse a whole source file looking for items of the
-- same class
parseCategory x = do
    res <- many x
    eof
    nonempty res

urls, titles, contents :: Parsec String () [String]

-- parse HTML source looking for URL tags of the search results
urls = parseCategory url where
    url = (try urlTag) <|> ignoreTag <|> ignoreText

-- parse HTML source looking for titles of the search results
titles = parseCategory title where
    title = (try titleTag) <|> ignoreTag <|> ignoreText

-- parse HTML source looking for descriptions of the search results
contents = parseCategory content where
    content = (try contentTag1) <|> (try contentTag2) <|>
        ignoreTag <|> ignoreText

-- parse the HTML source three times looking for URL, title and
-- description of all search results and return them as a list of
-- YahooSearchItem
items :: String -> [YahooSearchItem]
items q =
    let ignoreOrKeep = either (const []) id
        us = ignoreOrKeep $ parse urls "" q
        ts = ignoreOrKeep $ parse titles "" q
        cs = ignoreOrKeep $ parse contents "" q
    in [ YahooSearchItem { itemUrl = u, itemTitle = t, itemContent = c } |
        (u, t, c) <- zip3 us ts cs ]
