{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Data.Aeson (Value)
import           Data.Default.Class (def)
import           Network.HTTP.Req
                    ( (/:)
                    , GET(..)
                    , NoReqBody(..)
                    , basicAuth
                    , https
                    , jsonResponse
                    , req
                    , responseBody
                    , runReq
                    )

main :: IO ()
main = do
    response <- runReq def $ req
            GET
            (https "httpbin.org" /: "basic-auth" /: "someuser" /: "somepassword")
            NoReqBody
            jsonResponse
            (basicAuth "someuser" "somepassword")
    print (responseBody response :: Value)
