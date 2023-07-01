#!/usr/bin/env runhaskell

{- The procedure to read a UTF-8 character is just:

   hGetChar :: Handle -> IO Char

   assuming that the encoding for the handle has been set to utf8.
-}

import System.Environment (getArgs)
import System.IO (
        Handle, IOMode (..),
        hGetChar, hIsEOF, hSetEncoding, stdin, utf8, withFile
    )
import Control.Monad (forM_, unless)
import Text.Printf (printf)
import Data.Char (ord)

processCharacters :: Handle -> IO ()
processCharacters h = do
  done <- hIsEOF h
  unless done $ do
    c <- hGetChar h
    putStrLn $ printf "U+%04X" (ord c)
    processCharacters h

processOneFile :: Handle -> IO ()
processOneFile h = do
  hSetEncoding h utf8
  processCharacters h

{- You can specify one or more files on the command line, or if no
   files are specified, it reads from standard input.
-}
main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> processOneFile stdin
    xs -> forM_ xs $ \name -> do
      putStrLn name
      withFile name ReadMode processOneFile
