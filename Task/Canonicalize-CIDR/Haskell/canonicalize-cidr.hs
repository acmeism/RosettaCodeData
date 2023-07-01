import Control.Monad (guard)
import Data.Bits ((.|.), (.&.), complement, shiftL, shiftR, zeroBits)
import Data.Maybe (listToMaybe)
import Data.Word (Word32, Word8)
import Text.ParserCombinators.ReadP (ReadP, char, readP_to_S)
import Text.Printf (printf)
import Text.Read.Lex (readDecP)

-- A 32-bit IPv4 address, with a netmask applied, and the number of leading bits
-- that are in the network portion of the address.
data CIDR = CIDR Word32 Word8

-- Convert a string to a CIDR, or nothing if it's invalid.
cidrRead :: String -> Maybe CIDR
cidrRead = listToMaybe . map fst . readP_to_S cidrP

-- Convert the CIDR to a string.
cidrShow :: CIDR -> String
cidrShow (CIDR addr n) = let (a, b, c, d) = octetsFrom addr
                         in printf "%u.%u.%u.%u/%u" a b c d n

-- Parser for the string representation of a CIDR.  For a successful parse the
-- string must have the form a.b.c.d/n, where each of a, b, c and d are decimal
-- numbers in the range [0, 255] and n is a decimal number in the range [0, 32].
cidrP :: ReadP CIDR
cidrP = do a <- octetP <* char '.'
           b <- octetP <* char '.'
           c <- octetP <* char '.'
           d <- octetP <* char '/'
           n <- netBitsP
           return $ CIDR (addrFrom a b c d .&. netmask n) n
  where octetP   = wordP 255
        netBitsP = wordP  32

-- Parser for a decimal string, whose value is in the range [0, lim].
--
-- We want the limit argument to be an Integer, so that we can detect values
-- that are too large, rather than having them silently wrap.
wordP :: Integral a => Integer -> ReadP a
wordP lim = do n <- readDecP
               guard $ n <= lim
               return $ fi n

-- The octets of an IPv4 address.
octetsFrom :: Word32 -> (Word8, Word8, Word8, Word8)
octetsFrom addr = (oct addr 3, oct addr 2, oct addr 1, oct addr 0)
  where oct w n = fi $ w `shiftR` (8*n) .&. 0xff

-- An IPv4 address from four octets.  `ipAddr4 1 2 3 4' is the address 1.2.3.4.
addrFrom :: Word8 -> Word8 -> Word8 -> Word8 -> Word32
addrFrom a b c d = 0 <<+ a <<+ b <<+ c <<+ d
  where w <<+ o = w `shiftL` 8 .|. fi o

-- The value `netmask n' is the netmask whose leftmost n bits are 1, and the
-- remainder are 0.
netmask :: Word8 -> Word32
netmask n = complement $ complement zeroBits `shiftR` fi n

fi :: (Integral a, Num b) => a -> b
fi = fromIntegral

test :: String -> IO ()
test str = do
  let cidrStr = maybe "invalid CIDR string" cidrShow (cidrRead str)
  printf "%-18s -> %s\n" str cidrStr

main :: IO ()
main = do
  test "87.70.141.1/22"
  test "36.18.154.103/12"
  test "62.62.197.11/29"
  test "67.137.119.181/4"
  test "161.214.74.21/24"
  test "184.232.176.184/18"

  test "184.256.176.184/12" -- octet value is too large
  test "184.232.176.184/33" -- netmask size is too large
  test "184.232.184/18"     -- too few components
