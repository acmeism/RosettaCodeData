import Control.Monad ((>=>), (>>=), forM_)
import Control.Monad.Primitive
import qualified Data.Vector as V
import qualified Data.Vector.Mutable as M
import System.Random.MWC

type MutVec m a = M.MVector (PrimState m) a

-- Perform an in-place shuffle of the vector, making it a single random cyclic
-- permutation of its initial value.  The vector is also returned for
-- convenience.
cyclicPermM :: PrimMonad m => Gen (PrimState m) -> MutVec m a -> m (MutVec m a)
cyclicPermM rand vec = forM_ [1..M.length vec-1] upd >> return vec
  where upd i = uniformR (0, i-1) rand >>= M.swap vec i

-- Return a vector that is a single random cyclic permutation of the argument.
cyclicPerm :: PrimMonad m => Gen (PrimState m) -> V.Vector a -> m (V.Vector a)
cyclicPerm rand = V.thaw >=> cyclicPermM rand >=> V.unsafeFreeze

--------------------------------------------------------------------------------

test :: Show a => [a] -> IO ()
test xs = do
  let orig = V.fromList xs
  cyc <- withSystemRandom . asGenIO $ \rand -> cyclicPerm rand orig
  putStrLn $ "original: " ++ show orig
  putStrLn $ "  cycled: " ++ show cyc

main :: IO ()
main = do
  test ([] :: [()])
  test [10 :: Int]
  test [10, 20 :: Int]
  test [10, 20, 30 :: Int]
  test [11..22 :: Int]
  -- Also works for other types.
  test "abcdef"
