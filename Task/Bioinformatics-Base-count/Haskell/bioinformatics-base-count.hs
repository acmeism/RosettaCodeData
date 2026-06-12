import Data.List       (group, sort)
import Data.List.Split (chunksOf)
import Text.Printf     (printf, IsChar(..), PrintfArg(..), fmtChar, fmtPrecision, formatString)

data DNABase = A | C | G | T deriving (Show, Read, Eq, Ord)
type DNASequence = [DNABase]

instance IsChar DNABase where
  toChar = head . show
  fromChar = read . pure

instance PrintfArg DNABase where
  formatArg x fmt = formatString (show x) (fmt { fmtChar = 's', fmtPrecision = Nothing })

test :: DNASequence
test = read . pure <$> concat
  [ "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG"
  , "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG"
  , "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT"
  , "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT"
  , "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG"
  , "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA"
  , "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT"
  , "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG"
  , "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC"
  , "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT" ]

chunkedDNASequence :: DNASequence -> [(Int, [DNABase])]
chunkedDNASequence = zip [50,100..] . chunksOf 50

baseCounts :: DNASequence -> [(DNABase, Int)]
baseCounts = fmap ((,) . head <*> length) . group . sort

main :: IO ()
main = do
  putStrLn "Sequence:"
  mapM_ (uncurry (printf "%3d: %s\n")) $ chunkedDNASequence test
  putStrLn "\nBase Counts:"
  mapM_ (uncurry (printf "%2s: %2d\n")) $ baseCounts test
  putStrLn (replicate 8 '-') >> printf " Σ: %d\n\n" (length test)
