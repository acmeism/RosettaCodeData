{-# LANGUAGE ViewPatterns #-}

module Main where

import System.Random (randomRIO)
import Text.Printf   (printf)

data PInfo = PInfo { stack :: Int
                   , score :: Int
                   , rolls :: Int
                   , next  :: Bool
                   , won   :: Bool
                   , name  :: String
                   }

type Strategy = [PInfo] -> IO ()

roll :: [PInfo] -> IO [PInfo]
roll (pinfo:xs) = do
  face <- randomRIO (1, 6)
  case (face, face + stack pinfo + score pinfo) of
      (1,_)            -> do
          printf "%s rolled 1 - stack is being resetted\n\n" (name pinfo)
          return $ pinfo { stack = 0, rolls = 0, next = True } : xs
      (_,x) | x >= 100 -> do
          printf "%s rolled %i - stack is now %i + score %i => %i - I won!\n" (name pinfo) face (face + stack pinfo) (score pinfo) x
          return $ pinfo { won = True } : xs
      (_,_)            -> do
          printf "%s rolled %i - stack is now %i\n" (name pinfo) face (face + (stack pinfo))
          return $ pinfo { stack = face + (stack pinfo), rolls = 1 + (rolls pinfo) } : xs

hold :: [PInfo] -> IO [PInfo]
hold (pinfo:xs) = do
  let score' = stack pinfo + score pinfo
  printf "%s holds - score is now %i\n\n" (name pinfo) score'
  return $ pinfo { score = score', stack = 0, rolls = 0, next = True } : xs


logic :: Strategy -> Strategy -> Strategy
logic _      _      ((won -> True)    : xs) = return ()
logic _      strat2 (p@(next -> True) : xs) = strat2 $ xs ++ [p { next = False }]
logic strat1 _      (pinfo            : xs) = strat1 (pinfo : xs)

strat1 :: Strategy
strat1 (pinfo:xs)
  | stack pinfo < 20 = roll (pinfo:xs) >>= logic strat1 strat2
  | otherwise        = hold (pinfo:xs) >>= logic strat1 strat2

strat2 :: Strategy
strat2 (pinfo:xs)
  | rolls pinfo < 4 = roll (pinfo:xs) >>= logic strat2 strat3
  | otherwise       = hold (pinfo:xs) >>= logic strat2 strat3

strat3 :: Strategy
strat3 (pinfo:xs)
  | rolls pinfo < 3 && score pinfo < 60 = roll (pinfo:xs) >>= logic strat3 strat4
  | stack pinfo < 20                    = roll (pinfo:xs) >>= logic strat3 strat4
  | otherwise                           = hold (pinfo:xs) >>= logic strat3 strat4

strat4 :: Strategy
strat4 (pinfo:xs) | score pinfo > 75 = roll (pinfo:xs) >>= logic strat4 strat1
strat4 (pinfo:xs) = do
  chance <- randomRIO (0, 3) :: IO Int
  case chance of
      0  -> hold (pinfo:xs) >>= logic strat4 strat1
      _  -> roll (pinfo:xs) >>= logic strat4 strat1

main :: IO ()
main = do
  let pInfo = PInfo 0 0 0 False False ""
      p1    = pInfo { name = "Peter"   }
      p2    = pInfo { name = "Mia"     }
      p3    = pInfo { name = "Liz"     }
      p4    = pInfo { name = "Stephen" }
  strat1 [p1, p2, p3, p4]
