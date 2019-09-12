import Data.List (genericLength)
import Numeric (showHex)
import Foreign.C

foreign import ccall "zlib.h crc32" zlib_crc32 ::
               CULong -> CString -> CUInt -> CULong

main :: IO ()
main = do
  let s = "The quick brown fox jumps over the lazy dog"
  ptr <- newCString s
  let r = zlib_crc32 0 ptr (genericLength s)
  putStrLn $ showHex r ""
