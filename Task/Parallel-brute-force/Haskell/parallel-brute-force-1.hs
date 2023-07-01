import           Control.Concurrent (setNumCapabilities)
import           Crypto.Hash        (hashWith, SHA256 (..), Digest)
import           Control.Monad      (replicateM, join, (>=>))
import           Control.Monad.Par  (runPar, get, spawnP)
import           Data.ByteString    (pack)
import           Data.List.Split    (chunksOf)
import           GHC.Conc           (getNumProcessors)
import           Text.Printf        (printf)

hashedValues :: [Digest SHA256]
hashedValues = read <$>
  [ "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
  , "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
  , "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad" ]

bruteForce :: Int -> [(String, String)]
bruteForce n = runPar $ join <$>
  (mapM (spawnP . foldr findMatch []) >=> mapM get) chunks
  where
    chunks = chunksOf (26^5 `div` n) $ replicateM 5 [97..122]
    findMatch s accum
      | hashed `elem` hashedValues = (show hashed, show bStr) : accum
      | otherwise = accum
      where
        bStr = pack s
        hashed = hashWith SHA256 bStr

main :: IO ()
main = do
  cpus <- getNumProcessors
  setNumCapabilities cpus
  printf "Using %d cores\n" cpus
  mapM_ (uncurry (printf "%s -> %s\n")) (bruteForce cpus)
