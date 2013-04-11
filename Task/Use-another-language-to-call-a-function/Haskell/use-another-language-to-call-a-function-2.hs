{-# LANGUAGE ForeignFunctionInterface #-}

module Called where

import Foreign
import Foreign.C.String (CString, withCStringLen)
import Foreign.C.Types

-- place a string into the buffer pointed to by ptrBuff (with size
-- pointed to by ptrSize). If successful, sets number of overwritten
-- bytes in ptrSize and returns 1, otherwise, it does nothing and
-- returns 0
query_hs ::  CString -> Ptr CSize -> IO CInt
query_hs ptrBuff ptrSize = withCStringLen "Here I am"
               (\(str, len) -> do
                   buffSize <- peek ptrSize
                   if sizeOf str > (fromIntegral buffSize)
                     then do
                       poke ptrSize 0
                       return 0
                     else do
                       poke ptrSize (fromIntegral len)
                       copyArray ptrBuff str len
                       return 1)

foreign export ccall query_hs :: CString -> Ptr CSize -> IO CInt
