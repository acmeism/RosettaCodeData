import Control.Monad.Random
import Control.Monad.State
import qualified Data.Map as M
import System.Random

-- s_of_n_creator :: Int -> a -> RandT StdGen (State (Int, [a])) [a]
s_of_n_creator :: Int -> a -> StateT (Int, [a]) (Rand StdGen) [a]
s_of_n_creator n v = do
  (i, vs) <- get
  let i' = i + 1
  if i' <= n
    then do
      let vs' = v : vs
      put (i', vs')
      pure vs'
    else do
      j <- getRandomR (1, i')
      if j > n
        then do
          put (i', vs)
          pure vs
        else do
          k <- getRandomR (0, n - 1)
          let (f, (_ : b)) = splitAt k vs
              vs' = v : f ++ b
          put (i', vs')
          pure vs'

sample :: Int -> Rand StdGen [Int]
sample n =
  let s_of_n = s_of_n_creator n
   in snd <$> execStateT (traverse s_of_n [0 .. 9 :: Int]) (0, [])

incEach :: (Ord a, Num b) => M.Map a b -> [a] -> M.Map a b
incEach m ks = foldl (\m' k -> M.insertWith (+) k 1 m') m ks

sampleInc :: Int -> M.Map Int Double -> Rand StdGen (M.Map Int Double)
sampleInc n m = do
  s <- sample n
  pure $ incEach m s

main :: IO ()
main = do
  let counts = M.empty :: M.Map Int Double
      n = 100000
  gen <- getStdGen
  counts <- evalRandIO $ foldM (\c _ -> sampleInc 3 c) M.empty [1 .. n]
  print (fmap (/ n) counts)
