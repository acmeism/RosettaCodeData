module GetHostName where

import Foreign.Marshal.Array ( allocaArray0, peekArray0 )
import Foreign.C.Types ( CInt(..), CSize(..) )
import Foreign.C.String ( CString, peekCString )
import Foreign.C.Error ( throwErrnoIfMinus1_ )

getHostName :: IO String
getHostName = do
  let size = 256
  allocaArray0 size $ \ cstr -> do
    throwErrnoIfMinus1_ "getHostName" $ c_gethostname cstr (fromIntegral size)
    peekCString cstr

foreign import ccall "gethostname"
   c_gethostname :: CString -> CSize -> IO CInt

main = do hostName <- getHostName
          putStrLn hostName
