import Data.List
import Numeric
import Control.Arrow
import Control.Monad
import Text.Printf
import System.Environment
import Data.Function

type Date = String
type Value = Double
type Flag = Bool

readFlg :: String -> Flag
readFlg = (> 0).read

readNum :: String -> Value
readNum = fst.head.readFloat

take2 = takeWhile(not.null).unfoldr (Just.splitAt 2)

parseData :: [String] -> (Date,[(Value,Flag)])
parseData = head &&& map(readNum.head &&& readFlg.last).take2.tail

sumAccs :: (Date,[(Value,Flag)]) -> (Date, ((Value,Int),[Flag]))
sumAccs = second (((sum &&& length).concat.uncurry(zipWith(\v f -> [v|f])) &&& snd).unzip)

maxNAseq :: [Flag] -> [(Int,Int)]
maxNAseq = head.groupBy((==) `on` fst).sortBy(flip compare)
           . concat.uncurry(zipWith(\i (r,b)->[(r,i)|not b]))
           . first(init.scanl(+)0). unzip
           . map ((fst &&& id).(length &&& head)). group

main = do
    file:_ <- getArgs
    f <- readFile file
    let dat :: [(Date,((Value,Int),[Flag]))]
        dat      = map (sumAccs. parseData. words).lines $ f
        summ     = ((sum *** sum). unzip *** maxNAseq.concat). unzip $ map snd dat
        totalFmt = "\nSummary\t\t accept: %d\t total: %.3f \taverage: %6.3f\n\n"
        lineFmt  = "%8s\t accept: %2d\t total: %11.3f \taverage: %6.3f\n"
        maxFmt   =  "Maximum of %d consecutive false readings, starting on line /%s/ and ending on line /%s/\n"
-- output statistics
    putStrLn "\nSome lines:\n"
    mapM_ (\(d,((v,n),_)) -> printf lineFmt d n v (v/fromIntegral n)) $ take 4 $ drop 2200 dat
    (\(t,n) -> printf totalFmt  n t (t/fromIntegral n)) $ fst summ
    mapM_ ((\(l, d1,d2) -> printf maxFmt l d1 d2)
              . (\(a,b)-> (a,(fst.(dat!!).(`div`24))b,(fst.(dat!!).(`div`24))(a+b)))) $ snd summ
