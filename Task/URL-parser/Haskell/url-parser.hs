module Main (main) where

import           Data.Foldable (for_)
import           Network.URI
                    ( URI
                    , URIAuth
                    , parseURI
                    , uriAuthority
                    , uriFragment
                    , uriPath
                    , uriPort
                    , uriQuery
                    , uriRegName
                    , uriScheme
                    , uriUserInfo
                    )

uriStrings :: [String]
uriStrings =
    [ "https://bob:pass@example.com/place"
    , "foo://example.com:8042/over/there?name=ferret#nose"
    , "urn:example:animal:ferret:nose"
    , "jdbc:mysql://test_user:ouupppssss@localhost:3306/sakila?profileSQL=true"
    , "ftp://ftp.is.co.za/rfc/rfc1808.txt"
    , "http://www.ietf.org/rfc/rfc2396.txt#header1"
    , "ldap://[2001:db8::7]/c=GB?objectClass?one"
    , "mailto:John.Doe@example.com"
    , "news:comp.infosystems.www.servers.unix"
    , "tel:+1-816-555-1212"
    , "telnet://192.0.2.16:80/"
    , "urn:oasis:names:specification:docbook:dtd:xml:4.1.2"
    ]

trimmedUriScheme :: URI -> String
trimmedUriScheme = init . uriScheme

trimmedUriUserInfo :: URIAuth -> Maybe String
trimmedUriUserInfo uriAuth =
    case uriUserInfo uriAuth of
        [] -> Nothing
        userInfo -> if last userInfo == '@' then Just (init userInfo) else Nothing

trimmedUriPath :: URI -> String
trimmedUriPath uri = case uriPath uri of '/' : t -> t; p -> p

trimmedUriQuery :: URI -> Maybe String
trimmedUriQuery uri = case uriQuery uri of '?' : t -> Just t; _ -> Nothing

trimmedUriFragment :: URI -> Maybe String
trimmedUriFragment uri = case uriFragment uri of '#' : t -> Just t; _ -> Nothing

main :: IO ()
main = do
    for_ uriStrings $ \uriString -> do
        case parseURI uriString of
            Nothing -> putStrLn $ "Could not parse" ++ uriString
            Just uri -> do
                putStrLn uriString
                putStrLn $ "  scheme = " ++ trimmedUriScheme uri
                case uriAuthority uri of
                    Nothing -> return ()
                    Just uriAuth -> do
                        case trimmedUriUserInfo uriAuth of
                            Nothing -> return ()
                            Just userInfo ->  putStrLn $ "  user-info = " ++ userInfo
                        putStrLn $ "  domain = " ++ uriRegName uriAuth
                        putStrLn $ "  port = " ++ uriPort uriAuth
                putStrLn $ "  path = " ++ trimmedUriPath uri
                case trimmedUriQuery uri of
                    Nothing -> return ()
                    Just query -> putStrLn $ "  query = " ++ query
                case trimmedUriFragment uri of
                    Nothing -> return ()
                    Just fragment ->  putStrLn $ "  fragment = " ++ fragment
        putStrLn ""
