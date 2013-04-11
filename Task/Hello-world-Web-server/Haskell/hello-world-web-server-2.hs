{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Char8 ()
import Network hiding ( accept )
import Network.Socket ( accept )
import Network.Socket.ByteString ( sendAll )
import Control.Monad ( forever )
import Control.Exception ( bracket, finally )
import Control.Concurrent ( forkIO )

main :: IO ()
main = bracket (listenOn $ PortNumber 8080) sClose loop where
  loop s = forever $ forkIO . request . fst =<< accept s
  request c = sendAll c response `finally` sClose c
  response = "HTTP/1.0 200 OK\nContent-Length: 16\n\nGoodbye, World!\n"
