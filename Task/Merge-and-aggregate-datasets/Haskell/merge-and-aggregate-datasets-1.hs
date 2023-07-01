import Data.List
import Data.Maybe
import System.IO (readFile)
import Text.Read (readMaybe)
import Control.Applicative ((<|>))

------------------------------------------------------------

newtype DB = DB { entries :: [Patient] }
  deriving Show

instance Semigroup DB where
  DB a <> DB b = normalize $ a <> b

instance Monoid DB where
  mempty = DB []

normalize :: [Patient] -> DB
normalize = DB
            . map mconcat
            . groupBy (\x y -> pid x == pid y)
            . sortOn pid

------------------------------------------------------------

data Patient = Patient { pid :: String
                       , name :: Maybe String
                       , visits :: [String]
                       , scores :: [Float] }
  deriving Show

instance Semigroup Patient where
  Patient p1 n1 v1 s1 <> Patient p2 n2 v2 s2 =
    Patient (fromJust $ Just p1 <|> Just p2)
            (n1 <|> n2)
            (v1 <|> v2)
            (s1 <|> s2)

instance Monoid Patient where
  mempty = Patient mempty mempty mempty mempty

------------------------------------------------------------

readDB :: String  -> DB
readDB = normalize
         . mapMaybe readPatient
         . readCSV

readPatient r = do
  i <- lookup "PATIENT_ID" r
  let n = lookup "LASTNAME" r
  let d = lookup "VISIT_DATE" r >>= readDate
  let s = lookup "SCORE" r >>= readMaybe
  return $ Patient i n (maybeToList d) (maybeToList s)
  where
    readDate [] = Nothing
    readDate d = Just d

readCSV :: String -> [(String, String)]
readCSV txt = zip header <$> body
  where
    header:body = splitBy ',' <$> lines txt
    splitBy ch = unfoldr go
      where
        go [] = Nothing
        go s  = Just $ drop 1 <$> span (/= ch) s
