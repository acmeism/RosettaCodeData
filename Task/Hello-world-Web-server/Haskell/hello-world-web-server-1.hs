{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Char8 ()
import Data.Conduit ( ($$), yield )
import Data.Conduit.Network ( ServerSettings(..), runTCPServer )

main :: IO ()
main = runTCPServer (ServerSettings 8080 "127.0.0.1") $ const (yield response $$)
  where response = "HTTP/1.0 200 OK\nContent-Length: 16\n\nGoodbye, World!\n"
