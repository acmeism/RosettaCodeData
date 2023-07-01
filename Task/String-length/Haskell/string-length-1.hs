import Data.Encoding
import Data.ByteString as B

strUTF8  :: ByteString
strUTF8  = encode UTF8  "Hello World!"

strUTF32 :: ByteString
strUTF32 = encode UTF32 "Hello World!"

strlenUTF8  = B.length strUTF8
strlenUTF32 = B.length strUTF32
