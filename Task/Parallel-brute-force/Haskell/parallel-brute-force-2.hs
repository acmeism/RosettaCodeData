import           Control.Concurrent      (forkIO, setNumCapabilities)
import           Control.Concurrent.Chan (Chan, newChan, readChan, writeList2Chan)
import           Control.Monad           (replicateM, replicateM_, forever)
import           Crypto.Hash             (SHA256(..), Digest, hashWith)
import           Data.Bifunctor          (first)
import           Data.ByteString         (ByteString, pack)
import           Data.Char               (isDigit)
import           Data.List.Split         (chunksOf)
import           Data.Word               (Word8)
import           GHC.Conc                (getNumProcessors)
import           System.Environment      (getArgs)
import           Text.Printf             (printf)

type Decrypted = String
type Encrypted = Digest SHA256
type TestString = [Word8]

hashedValues :: [Encrypted]
hashedValues = read <$>
  [ "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
  , "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
  , "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad" ]

chunks :: [[TestString]]
chunks = chunksOf (10^3) $ replicateM 5 [97..122]

findMatch :: TestString -> [(Encrypted, Decrypted)] -> [(Encrypted, Decrypted)]
findMatch w acc
  | hashed `elem` hashedValues = (hashed, show bStr):acc
  | otherwise = acc
  where
    bStr = pack w
    hashed = hashWith SHA256 bStr

searchWorker :: Chan [TestString] -> Chan (Encrypted, Decrypted) -> IO ()
searchWorker batchChan resultChan = forever (readChan batchChan >>= writeList2Chan resultChan . foldr findMatch [])

parseInput :: [String] -> Int -> Int
parseInput [] n    = n
parseInput (s:_) n = if all isDigit s then read s else n

main :: IO ()
main = do
  workers <- getArgs
  cpus <- getNumProcessors
  let wCount = parseInput workers cpus
  setNumCapabilities wCount
  printf "Using %d workers on %d cpus.\n" wCount cpus
  resultChan <- newChan
  batchChan <- newChan
  replicateM_ wCount (forkIO $ searchWorker batchChan resultChan)
  writeList2Chan batchChan chunks
  replicateM_ (length hashedValues) (readChan resultChan >>= uncurry (printf "%s -> %s\n") . first show)
