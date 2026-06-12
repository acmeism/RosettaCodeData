#!/bin/bash
sed -n -e '7,$p' < "$0" > $0.$$.hs
ghc $0.$$.hs > /dev/null
./$0.$$ "$0" "$@"
rm $0.$$*
exit
import Text.Printf
import System.Environment

main :: IO ()
main = getArgs >>= mapM_ (uncurry $ printf "argv[%d] -> %s\n") . zip ([0..] :: [Int])
