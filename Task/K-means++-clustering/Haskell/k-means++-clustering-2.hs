module Main where

import Graphics.EasyPlot
import Data.Monoid

import KMeans

test = do datum <- mkCluster 1000 0.5 [0,0,1]
                <> mkCluster 2000 0.5 [2,3,1]
                <> mkCluster 3000 0.5 [2,-3,0]
          cls <- kMeansPP 3 datum
          mapM_ (\x -> print (centroid x, length x)) cls

main = do datum  <- sequence [ mkCluster 30100 0.3 [0,0]
                             , mkCluster 30200 0.4 [2,3]
                             , mkCluster 30300 0.5 [2,-3]
                             , mkCluster 30400 0.6 [6,0]
                             , mkCluster 30500 0.7 [-3,-3]
                             , mkCluster 30600 0.8 [-5,5] ]
          cls <- kMeansPP 6 (mconcat datum)
          plot (PNG "plot1.png") $ map listPlot cls
            where
              listPlot = Data2D [Title "",Style Dots] [] . map (\(x:y:_) -> (x,y))
