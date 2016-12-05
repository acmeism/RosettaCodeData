{-# LANGUAGE LambdaCase #-}
module Main where

import Control.Error (tryRead, tryAt)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Except (ExceptT, runExceptT)

import Data.Char
import System.Exit (die)
import System.Environment (getArgs)

main :: IO ()
main = runExceptT parseKey >>= \case
           Left err -> die err
           Right k  -> interact $ caesar k

parseKey :: (Read a, Integral a) => ExceptT String IO a
parseKey = liftIO getArgs >>=
           flip (tryAt "Not enough arguments") 0 >>=
           tryRead "Key is not a valid integer"

caesar :: (Integral a) => a -> String -> String
caesar k = map f
    where f c = case generalCategory c of
              LowercaseLetter -> addChar 'a' k c
              UppercaseLetter -> addChar 'A' k c
              _               -> c

addChar :: (Integral a) => Char -> a -> Char -> Char
addChar b o c = chr $ fromIntegral (b' + (c' - b' + o) `mod` 26)
    where b' = fromIntegral $ ord b
          c' = fromIntegral $ ord c
