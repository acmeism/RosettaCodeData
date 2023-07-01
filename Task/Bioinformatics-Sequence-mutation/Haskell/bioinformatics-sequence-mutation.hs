import Data.List       (group, sort)
import Data.List.Split (chunksOf)
import System.Random   (Random, randomR, random, newStdGen, randoms, getStdRandom)
import Text.Printf     (PrintfArg(..), fmtChar, fmtPrecision, formatString, IsChar(..), printf)

data Mutation = Swap | Delete | Insert deriving (Show, Eq, Ord, Enum, Bounded)
data DNABase = A | C | G | T deriving (Show, Read, Eq, Ord, Enum, Bounded)
type DNASequence = [DNABase]

data Result = Swapped Mutation Int (DNABase, DNABase)
            | InsertDeleted Mutation Int DNABase

instance Random DNABase where
  randomR (a, b) g = case randomR (fromEnum a, fromEnum b) g of (x, y) -> (toEnum x, y)
  random = randomR (minBound, maxBound)

instance Random Mutation where
  randomR (a, b) g = case randomR (fromEnum a, fromEnum b) g of (x, y) -> (toEnum x, y)
  random = randomR (minBound, maxBound)

instance PrintfArg DNABase where
  formatArg x fmt = formatString (show x) (fmt { fmtChar = 's', fmtPrecision = Nothing })

instance PrintfArg Mutation where
  formatArg x fmt = formatString (show x) (fmt { fmtChar = 's', fmtPrecision = Nothing })

instance IsChar DNABase where
  toChar = head . show
  fromChar = read . pure

chunkedDNASequence :: DNASequence -> [(Int, [DNABase])]
chunkedDNASequence = zip [50,100..] . chunksOf 50

baseCounts :: DNASequence -> [(DNABase, Int)]
baseCounts = fmap ((,) . head <*> length) . group . sort

newSequence :: Int -> IO DNASequence
newSequence n = take n . randoms <$> newStdGen

mutateSequence :: DNASequence -> IO (Result, DNASequence)
mutateSequence [] = fail "empty dna sequence"
mutateSequence ds = randomMutation >>= mutate ds
  where
    randomMutation = head . randoms <$> newStdGen
    mutate xs m = do
      i <- randomIndex (length xs)
      case m of
        Swap   -> randomDNA >>= \d -> pure (Swapped Swap i (xs !! pred i, d), swapElement i d xs)
        Insert -> randomDNA >>= \d -> pure (InsertDeleted Insert i d, insertElement i d xs)
        Delete -> pure (InsertDeleted Delete i (xs !! pred i), dropElement i xs)
      where
        dropElement i xs = take (pred i) xs <> drop i xs
        insertElement i e xs = take i xs <> [e] <> drop i xs
        swapElement i a xs = take (pred i) xs <> [a] <> drop i xs
        randomIndex n = getStdRandom (randomR (1, n))
        randomDNA = head . randoms <$> newStdGen

mutate :: Int -> DNASequence -> IO DNASequence
mutate 0 s = pure s
mutate n s = do
  (r, ms) <- mutateSequence s
  case r of
    Swapped m i (a, b)  -> printf "%6s @ %-3d : %s -> %s \n" m i a b
    InsertDeleted m i a -> printf "%6s @ %-3d : %s\n" m i a
  mutate (pred n) ms

main :: IO ()
main = do
  ds <- newSequence 200
  putStrLn "\nInitial Sequence:" >> showSequence ds
  putStrLn "\nBase Counts:" >> showBaseCounts ds
  showSumBaseCounts ds
  ms <- mutate 10 ds
  putStrLn "\nMutated Sequence:" >> showSequence ms
  putStrLn "\nBase Counts:" >> showBaseCounts ms
  showSumBaseCounts ms
  where
    showSequence   = mapM_ (uncurry (printf "%3d: %s\n")) . chunkedDNASequence
    showBaseCounts = mapM_ (uncurry (printf "%s: %3d\n")) . baseCounts
    showSumBaseCounts xs = putStrLn (replicate 6 '-') >> printf "Σ: %d\n\n" (length xs)
