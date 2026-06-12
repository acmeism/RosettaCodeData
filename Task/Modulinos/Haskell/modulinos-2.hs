#!/usr/bin/env runhaskell

-- Compile:
--
-- ghc -fforce-recomp -o scriptedmain -main-is ScriptedMain scriptedmain.hs

module ScriptedMain where

meaningOfLife :: Int
meaningOfLife = 42

main :: IO ()
main = putStrLn $ "Main: The meaning of life is " ++ show meaningOfLife
