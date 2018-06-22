import Network.Browser
import Network.HTTP
import Network.URI

main = do
    rsp <- Network.Browser.browse $ do
        setAllowRedirects True
        setOutHandler $ const (return ())
        request $ getRequest "http://www.rosettacode.org/"
    putStrLn $ rspBody $ snd rsp
