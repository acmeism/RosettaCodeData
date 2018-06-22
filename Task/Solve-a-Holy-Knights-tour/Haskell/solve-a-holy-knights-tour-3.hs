{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -ddump-simpl -ddump-to-file -ddump-stg -O2 -fforce-recomp #-}
module Main (main) where

import           Control.Monad.ST (runST)
import           Data.List (intercalate, transpose)
import qualified Data.Ix as Ix
import qualified Data.Vector as V
import           Data.Vector.Unboxed (Vector)
import qualified Data.Vector.Unboxed         as U
import qualified Data.Vector.Unboxed.Mutable as MU
import           Data.Foldable (for_)

type Position = ( Int, Int )

type Bounds = (Position, Position)

type KnightBoard = (Bounds, Vector Int)

toSlot :: Char -> Int
toSlot '0' = 0
toSlot '1' = 1
toSlot _ = -1

toString :: Int -> String
toString (-1) = replicate 3 ' '
toString n = replicate (3 - length nn) ' ' ++ nn
 where
   nn = show n

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = uncurry ((. chunksOf n) . (:)) (splitAt n xs)

showBoard :: KnightBoard -> String
showBoard (bounds, board) =
 intercalate "\n" . map concat . transpose . chunksOf (height + 1) . map toString $
   U.toList board
 where
   (_, (_, height)) = bounds

toBoard :: [String] -> KnightBoard
toBoard strs = (((0,0),(width-1,height-1)), board)
 where
   height = length strs
   width = minimum (length <$> strs)
   board =
     U.fromListN (width*height) . map toSlot . concat . transpose $
     take width <$> strs

-- Solve the knight's tour with a simple Depth First Search.
solveKnightTour :: KnightBoard -> Maybe KnightBoard
solveKnightTour (bounds@(_,(_,yb)), board) = runST $ do
 array <- U.thaw board
 let maxDepth = U.length $ U.filter (/= (-1)) board
     Just iniIdx = U.findIndex (==1) board
     initPosition = mkPos iniIdx
     !hops = V.generate  (U.length board) $ \i ->
       if board `U.unsafeIndex` i == -1
       then U.empty
       else mkHops (mkPos i)

     solve !depth !position = MU.unsafeRead array position >>= \case
       0 -> do
         MU.unsafeWrite array position depth
         case depth == maxDepth of
           True -> return True
           False -> do
             results <- U.mapM (solve (depth + 1)) (hops `V.unsafeIndex` position)
             if U.or results
               then return True
               else do
                 MU.unsafeWrite array position 0
                 return False
       _ -> pure False

 MU.unsafeWrite array (Ix.index bounds initPosition) 0
 result <- solve 1 (Ix.index bounds initPosition)
 farray <- U.unsafeFreeze array
 return $ if result then Just (bounds, farray) else Nothing
 where
   offsets = U.fromListN 8 [ (1, 2), (2, 1), (2, -1), (-1, 2), (-2, 1), (1, -2), (-1, -2), (-2, -1) ]
   mkHops pos = U.filter (\i -> board `U.unsafeIndex` i == 0)
              $ U.map (Ix.index bounds)
              $ U.filter (Ix.inRange bounds)
              $ U.map (add pos) offsets
   add (x, y) (x', y') = (x + x', y + y')
   mkPos idx = idx `quotRem` (yb+1)


tourExA :: [String]
tourExA =
 [ " 000    "
 , " 0 00   "
 , " 0000000"
 , "000  0 0"
 , "0 0  000"
 , "1000000 "
 , "  00 0  "
 , "   000  "
 ]

tourExB :: [String]
tourExB =
 [ "-----1-0-----"
 , "-----0-0-----"
 , "----00000----"
 , "-----000-----"
 , "--0--0-0--0--"
 , "00000---00000"
 , "--00-----00--"
 , "00000---00000"
 , "--0--0-0--0--"
 , "-----000-----"
 , "----00000----"
 , "-----0-0-----"
 , "-----0-0-----"
 ]

main :: IO ()
main =
 for_
   [tourExA, tourExB]
   (\board -> do
       case solveKnightTour $ toBoard board of
         Nothing -> putStrLn "No solution.\n"
         Just solution -> putStrLn $ showBoard solution ++ "\n")
