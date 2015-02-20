{-# LANGUAGE LambdaCase, TupleSections #-}
import qualified Data.HashTable.ST.Basic as H
import Data.Hashable
import Control.Monad.ST
import Control.Monad
import Data.STRef

hashJoin :: (Eq k, Hashable k) =>
            [t] -> (t -> k) -> [a] -> (a -> k) -> [(t, a)]
hashJoin xs fx ys fy = runST $ do
  l <- newSTRef []
  ht <- H.new
  forM_ ys $ \y -> H.insert ht (fy y) =<<
    (H.lookup ht (fy y) >>= \case
      Nothing -> return [y]
      Just v -> return (y:v))
  forM_ xs $ \x -> do
    H.lookup ht (fx x) >>= \case
      Nothing -> return ()
      Just v -> modifySTRef' l ((map (x,)  v) ++)
  readSTRef l

test = mapM_ print $ hashJoin
    [(1, "Jonah"), (2, "Alan"), (3, "Glory"), (4, "Popeye")]
        snd
    [("Jonah", "Whales"), ("Jonah", "Spiders"),
      ("Alan", "Ghosts"), ("Alan", "Zombies"), ("Glory", "Buffy")]
        fst
