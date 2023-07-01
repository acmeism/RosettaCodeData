import Data.Fixed
import Text.Printf

type Percent = Centi
type Dollars = Centi

tax :: Percent -> Dollars -> Dollars
tax rate = MkFixed . round . (rate *)

printAmount :: String -> Dollars -> IO ()
printAmount name = printf "%-10s %20s\n" name . showFixed False

main :: IO ()
main = do
  let subtotal = 4000000000000000 * 5.50 + 2 * 2.86
      tx       = tax 7.65 subtotal
      total    = subtotal + tx
  printAmount "Subtotal" subtotal
  printAmount "Tax"      tx
  printAmount "Total"    total
