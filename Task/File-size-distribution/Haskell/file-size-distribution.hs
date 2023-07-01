{-# LANGUAGE LambdaCase #-}

import           Control.Concurrent          (forkIO, setNumCapabilities)
import           Control.Concurrent.Chan     (Chan, newChan, readChan,
                                              writeChan, writeList2Chan)
import           Control.Exception           (IOException, catch)
import           Control.Monad               (filterM, forever, join,
                                              replicateM, replicateM_, (>=>))
import           Control.Parallel.Strategies (parTraversable, rseq, using,
                                              withStrategy)
import           Data.Char                   (isDigit)
import           Data.List                   (find, sort)
import qualified Data.Map.Strict             as Map
import           GHC.Conc                    (getNumProcessors)
import           System.Directory            (doesDirectoryExist, doesFileExist,
                                              listDirectory,
                                              pathIsSymbolicLink)
import           System.Environment          (getArgs)
import           System.FilePath.Posix       ((</>))
import           System.IO                   (FilePath, IOMode (ReadMode),
                                              hFileSize, hPutStrLn, stderr,
                                              withFile)
import           Text.Printf                 (hPrintf, printf)

data Item = File FilePath Integer | Folder FilePath deriving (Show)

type FGKey = (Integer, Integer)
type FrequencyGroup = (FGKey, Integer)
type FrequencyGroups = Map.Map FGKey Integer

newFrequencyGroups :: FrequencyGroups
newFrequencyGroups = Map.empty

fileSizes :: [Item] -> [Integer]
fileSizes = foldr f [] where f (File _ n) acc = n:acc
                             f _          acc = acc

folders :: [Item] -> [FilePath]
folders = foldr f [] where f (Folder p) acc = p:acc
                           f _          acc = acc

totalBytes :: [Item] -> Integer
totalBytes = sum . fileSizes

counts :: [Item] -> (Integer, Integer)
counts = foldr (\x (a, b) -> case x of File _ _ -> (succ a, b)
                                       Folder _ -> (a, succ b)) (0, 0)

-- |Creates 'FrequencyGroups' from the provided size and data set.
frequencyGroups :: Int             -- ^ Desired number of frequency groups.
                -> [Integer]       -- ^ List of collected file sizes. Must be sorted.
                -> FrequencyGroups -- ^ Returns a 'FrequencyGroups' for the file sizes.
frequencyGroups _ [] = newFrequencyGroups
frequencyGroups totalGroups xs
  | length xs == 1 = Map.singleton (head xs, head xs) 1
  | otherwise = foldr placeGroups newFrequencyGroups xs `using` parTraversable rseq
  where
    range = maximum xs - minimum xs
    groupSize = succ $ ceiling $ realToFrac range / realToFrac totalGroups
    groups = takeWhile (<=groupSize + maximum xs) $ iterate (+groupSize) 0
    groupMinMax = zip groups (pred <$> tail groups)
    findGroup n = find (\(low, high) -> n >= low && n <= high)

    incrementCount (Just n) = Just (succ n) -- Update count for range.
    incrementCount Nothing  = Just 1        -- Insert new range with initial count.

    placeGroups n fgMap = case findGroup n groupMinMax of
      Just k  -> Map.alter incrementCount k fgMap
      Nothing -> fgMap -- Should never happen.

expandGroups :: Int             -- ^ Desired number of frequency groups.
             -> [Integer]       -- ^ List of collected file sizes.
             -> Integer         -- ^ Computed frequency group limit.
             -> FrequencyGroups -- ^ Expanded 'FrequencyGroups'
expandGroups gsize fileSizes groupThreshold
  | groupThreshold > 0 = loop 15 $ frequencyGroups gsize sortedFileSizes
  | otherwise = frequencyGroups gsize sortedFileSizes
  where
    sortedFileSizes = sort fileSizes
    loop 0 gs = gs -- break out in case we can't go below threshold
    loop n gs | all (<= groupThreshold) $ Map.elems gs = gs
              | otherwise = loop (pred n) (expand gs)

    expand :: FrequencyGroups -> FrequencyGroups
    expand = foldr f . withStrategy (parTraversable rseq) <*>
      Map.mapWithKey groupsFromGroup . Map.filter (> groupThreshold)
      where
        f :: Maybe (FGKey, FrequencyGroups) -- ^ expanded frequency group
          -> FrequencyGroups                -- ^ accumulator
          -> FrequencyGroups                -- ^ merged accumulator
        f (Just (k, fg)) acc = Map.union (Map.delete k acc) fg
        f Nothing        acc = acc

        groupsFromGroup
          :: FGKey                          -- ^ Group Key
          -> Integer                        -- ^ Count
          -> Maybe (FGKey, FrequencyGroups) -- ^ Returns expanded 'FrequencyGroups' with base key it replaces.
        groupsFromGroup (min, max) count
          | length range > 1 = Just ((min, max), frequencyGroups gsize range)
          | otherwise        = Nothing
          where
            range = filter (\n -> n >= min && n <= max) sortedFileSizes

displaySize :: Integer -> String
displaySize n
  |              n <= 2^10 = printf "%8dB " n
  | n >= 2^10 && n <= 2^20 = display (2^10) "KB"
  | n >= 2^20 && n <= 2^30 = display (2^20) "MB"
  | n >= 2^30 && n <= 2^40 = display (2^30) "GB"
  | n >= 2^40 && n <= 2^50 = display (2^40) "TB"
  | otherwise = "Too large!"
  where
    display :: Double -> String -> String
    display b = printf "%7.2f%s " (realToFrac n / b)

displayFrequency :: Integer -> FrequencyGroup -> IO ()
displayFrequency filesCount ((min, max), count) = do
  printf "%s <-> %s" (displaySize min) (displaySize max)
  printf "= %-10d %6.3f%%: %-5s\n" count percentage bars
  where
    percentage :: Double
    percentage = (realToFrac count / realToFrac filesCount) * 100
    size = round percentage
    bars | size == 0 = "▍"
         | otherwise = replicate size '█'

folderWorker :: Chan FilePath -> Chan [Item] -> IO ()
folderWorker folderChan resultItemsChan =
  forever (readChan folderChan >>= collectItems >>= writeChan resultItemsChan)

collectItems :: FilePath -> IO [Item]
collectItems folderPath = catch tryCollect $ \e -> do
    hPrintf stderr "Skipping: %s\n" $ show (e :: IOException)
    pure []
  where
    tryCollect = (fmap (folderPath </>) <$> listDirectory folderPath) >>=
      mapM (\p -> doesDirectoryExist p >>=
              \case True  -> pure $ Folder p
                    False -> File p <$> withFile p ReadMode hFileSize)

parallelItemCollector :: FilePath -> IO [Item]
parallelItemCollector folder = do
  wCount <- getNumProcessors
  setNumCapabilities wCount
  printf "Using %d worker threads\n" wCount
  folderChan <- newChan
  resultItemsChan <- newChan
  replicateM_ wCount (forkIO $ folderWorker folderChan resultItemsChan)
  loop folderChan resultItemsChan [Folder folder]
  where
    loop :: Chan FilePath -> Chan [Item] -> [Item] -> IO [Item]
    loop folderChan resultItemsChan xs = do
      regularFolders <- filterM (pathIsSymbolicLink >=> (pure . not)) $ folders xs
      if null regularFolders then pure []
      else do
        writeList2Chan folderChan regularFolders
        childItems <- replicateM (length regularFolders) (readChan resultItemsChan)
        result <- mapM (loop folderChan resultItemsChan) childItems
        pure (join childItems <> join result)

parseArgs :: [String] -> Either String (FilePath, Int)
parseArgs (x:y:xs)
  | all isDigit y = Right (x, read y)
  | otherwise     = Left "Invalid frequency group size"
parseArgs (x:xs) = Right (x, 4)
parseArgs _ = Right (".", 4)

main :: IO ()
main = parseArgs <$> getArgs >>= \case
    Left errorMessage -> hPutStrLn stderr errorMessage
    Right (path, groupSize) -> do
      items <- parallelItemCollector path
      let (fileCount, folderCount) = counts items
      printf "Total files: %d\nTotal folders: %d\n" fileCount folderCount
      printf "Total size: %s\n" $ displaySize $ totalBytes items
      printf "\nDistribution:\n\n%9s  <-> %9s %7s\n" "From" "To" "Count"
      putStrLn $ replicate 46 '-'
      let results = expandGroups groupSize (fileSizes items) (groupThreshold fileCount)
      mapM_ (displayFrequency fileCount) $ Map.assocs results
  where
    groupThreshold = round . (*0.25) . realToFrac
