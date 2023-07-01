import Data.List
import Network.HTTP (simpleHTTP, getResponseBody, getRequest)

tyd = "http://tycho.usno.navy.mil/cgi-bin/timer.pl"

readUTC = simpleHTTP (getRequest tyd)>>=
            fmap ((!!2).head.dropWhile ("UTC"`notElem`).map words.lines). getResponseBody>>=putStrLn
