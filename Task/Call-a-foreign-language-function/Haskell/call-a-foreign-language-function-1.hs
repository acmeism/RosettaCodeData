{-# LANGUAGE ForeignFunctionInterface #-}

import Foreign (free)
import Foreign.C.String (CString, withCString, peekCString)

-- import the strdup function itself
-- the "unsafe" means "assume this foreign function never calls back into Haskell and avoid extra bookkeeping accordingly"
foreign import ccall unsafe "string.h strdup" strdup :: CString -> IO CString

testC = withCString "Hello World!" -- marshall the Haskell string "Hello World!" into a C string...
        (\s -> -- ... and name it s
         do s2 <- strdup s
            s2_hs <- peekCString s2 -- marshall the C string called s2 into a Haskell string named s2_hs
            putStrLn s2_hs
            free s2) -- s is automatically freed by withCString once done
