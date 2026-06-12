#!/bin/bash
{- 2> /dev/null
exec runghc $0 $0 $@
-}
import Text.Printf
import System.Environment

main :: IO ()
main = getArgs >>= mapM_ (uncurry $ printf "argv[%d] -> %s\n") . zip ([0..] :: [Int])
