import qualified Data.Map as M

-- only for fancy output
import Text.Printf
import Data.List.Split
import Control.Monad

-- Jordan-Polya numbers and decompositions
jpns3 :: [(Integer,[Int])]
jpns3 = ((1,[]) :) $ go (M.singleton 2 [1])
  where
    facts = scanl1 (*) [2 ..]
    ones = iterate (0 :) (1 : zeros)
    zeros = 0 : zeros

    go q = res : go (qc $ M.unionWith unifun q1 q2)
      where
        (res@(jpn, es), q1) = M.deleteFindMin q
        es1 = 0 : es
        jpn1 = fst $ last $ zip facts es1
        qc = if sum es == 1 then M.insert jpn1 es1 else id
        q2 = M.fromList [(jpn * f, zipWith (+) one es) | (f, one, _) <- zip3 facts ones es]

    unifun as bs = snd $ max
      ((length as, reverse as), as)
      ((length bs, reverse bs), bs)

main = do
  putStrLn "First 50 Jordan-Pólya numbers:"
  putStrLn $ unlines $ chunksOf 50 $ concatMap (printf "%5d") $ take 50 $ map fst jpns3
  printf "The largest Jordan-Pólya number before 100 millon: %d\n" $ last $ takeWhile (100_000_000 >) $ map fst jpns3
  forM_ [800,1050,1800,2800,3800] (\i -> do
    let (n,dc) = jpns3 !! pred i
    printf "\nThe %dth Jordan-Pólya number is : %d\n" i n
    putStrLn $ intercalate " * " $ map (uncurry (printf "(%d!)^%d")) $ filter ((0 <) . snd) $ zip [2 :: Int ..] dc
    )
