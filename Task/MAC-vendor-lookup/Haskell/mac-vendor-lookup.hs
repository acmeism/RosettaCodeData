#!/usr/bin/env stack
{- stack
  script
  --resolver lts-9.0
  --package bytestring
  --package http-client
  --package http-types
-}

{-# LANGUAGE MultiWayIf #-}

import Control.Exception (try)
import Control.Monad (forM_)
import qualified Data.ByteString.Lazy.Char8 as L8 (ByteString, unpack)
import Network.HTTP.Client
  (Manager, parseRequest, httpLbs, responseStatus, responseBody,
   newManager, defaultManagerSettings, Response, HttpException)
import Network.HTTP.Types.Status (statusIsSuccessful, notFound404)
import System.Environment (getArgs)
import Text.Printf (printf)

fetchURL :: Manager
         -> String
         -> IO (Either HttpException (Response L8.ByteString))
fetchURL mgr url = try $ do
  req <- parseRequest url
  httpLbs req mgr

lookupMac :: Manager -> String -> IO String
lookupMac mgr mac = do
  eth <- fetchURL mgr $ "http://api.macvendors.com/" ++ mac
  return $ case eth of
             Left _ -> "null"
             Right resp -> let body = responseBody resp
                               status = responseStatus resp
                           in if | status == notFound404 -> "N/A"
                                 | not (statusIsSuccessful status) -> "null"
                                 | otherwise -> L8.unpack body

main :: IO ()
main = do
  args <- getArgs
  mgr <- newManager defaultManagerSettings
  forM_ args $ \mac -> do
    putStr $ printf "%-17s" mac ++ " = "
    vendor <- lookupMac mgr mac
    putStrLn vendor
