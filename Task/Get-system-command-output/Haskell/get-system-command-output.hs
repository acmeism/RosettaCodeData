#!/usr/bin/env stack
-- stack --resolver lts-8.15 --install-ghc runghc --package process

import System.Process (readProcess)

main :: IO ()
main = do
    -- get the output of the process as a list of lines
    results <- lines <$> readProcess "hexdump" ["-C", "/etc/passwd"] ""

    -- print each line in reverse
    mapM_ (putStrLn . reverse) results
