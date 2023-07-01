#!/usr/bin/env runhaskell

import Data.ByteString.Char8 (pack)
import System.Environment (getArgs)
import Crypto.Hash

main :: IO ()
main = print . md4 . pack . unwords =<< getArgs
         where md4 x = hash x :: Digest MD4
