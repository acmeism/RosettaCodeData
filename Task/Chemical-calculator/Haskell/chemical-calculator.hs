import Control.Monad (forM_)
import Control.Monad.Reader (Reader, ask, runReader)
import Data.Bifunctor (first)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Void (Void)
import System.Environment (getArgs)
import System.IO (IOMode(ReadMode), withFile)
import System.IO.Strict (hGetContents)
import Text.Megaparsec (ParsecT, (<|>), between, errorBundlePretty, getOffset,
                        many, option, runParserT, some, setOffset)
import Text.Megaparsec.Char (char, lowerChar, upperChar)
import Text.Megaparsec.Char.Lexer (decimal)
import Text.Printf (printf)

type Masses     = Map String Double
type ChemParser = ParsecT Void String (Reader Masses) Double

-- Parse the formula of a molecule, returning the latter's total mass.
molecule :: ChemParser
molecule = sum <$> some (atomGroup <|> atom)

-- Parse an atom group, optionally followed by its count, returning its total
-- mass.
atomGroup :: ChemParser
atomGroup = mul <$> between (char '(') (char ')') molecule <*> option 1 decimal

-- Parse an atom name, optionally followed by a count, returning its total mass.
atom :: ChemParser
atom = mul <$> atomMass <*> option 1 decimal

-- Parse an atom name, returning its mass.  Fail if the name is unknown.
atomMass :: ChemParser
atomMass = do
  off <- getOffset
  masses <- ask
  atomName <- (:) <$> upperChar <*> many lowerChar
  case M.lookup atomName masses of
    Nothing -> setOffset off >> fail "invalid atom name starting here"
    Just mass -> return mass

-- Given a molecular formula and a map from atom names to their masses, return
-- the the total molar mass, or an error message if the formula can't be parsed.
molarMass :: String -> String -> Masses -> Either String Double
molarMass file formula = first errorBundlePretty . runChemParser
  where runChemParser = runReader (runParserT molecule file formula)

-- Read from a file the map from atom names to their masses.
getMasses :: FilePath -> IO Masses
getMasses path = withFile path ReadMode (fmap read . hGetContents)

mul :: Double -> Int -> Double
mul s n = s * fromIntegral n

main :: IO ()
main = do
  masses <- getMasses "chemcalc_masses.in"
  molecs <- getArgs
  forM_ molecs $ \molec -> do
    printf "%-20s" molec
    case molarMass "<stdin>" molec masses of
      Left err   -> printf "\n%s" err
      Right mass -> printf " %.4f\n" mass
