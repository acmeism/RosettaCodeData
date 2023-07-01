import Data.Text (pack, split, unpack)
import Data.List (sort, intercalate)

-- SORTING OBJECT IDENTIFIERS ------------------------------------------------
oidSort :: [String] -> [String]
oidSort =
  fmap (intercalate "." . fmap show) .
  sort . fmap (fmap readInt . splitString '.')

-- GENERIC FUNCTIONS ---------------------------------------------------------
splitString :: Char -> String -> [String]
splitString c s = unpack <$> split (c ==) (pack s)

readInt :: String -> Int
readInt xs = read xs :: Int

-- TEST ----------------------------------------------------------------------
main :: IO ()
main =
  mapM_ putStrLn $
  oidSort
    [ "1.3.6.1.4.1.11.2.17.19.3.4.0.10"
    , "1.3.6.1.4.1.11.2.17.5.2.0.79"
    , "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
    , "1.3.6.1.4.1.11150.3.4.0.1"
    , "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
    , "1.3.6.1.4.1.11150.3.4.0"
    ]
