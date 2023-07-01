#!/usr/bin/env runhaskell

import Data.ByteString.Char8 (pack)
import System.Environment (getArgs)
import Crypto.Hash

main :: IO ()
main = print . md5 . pack . unwords =<< getArgs
         where md5 x = hash x :: Digest MD5
