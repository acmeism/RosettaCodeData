#!/usr/bin/env stack
-- stack --resolver lts-6.33 --install-ghc runghc --package unix

import Control.Exception ( try )
import Foreign ( FunPtr, allocaBytes )
import Foreign.C
    ( CSize(..), CString, withCAStringLen, peekCAStringLen )
import System.Info ( os )
import System.IO.Error ( ioeGetErrorString )
import System.IO.Unsafe ( unsafePerformIO )
import System.Posix.DynamicLinker
    ( RTLDFlags(RTLD_LAZY), dlsym, dlopen )

dlSuffix :: String
dlSuffix = if os == "darwin" then ".dylib" else ".so"

type RevFun = CString -> CString -> CSize -> IO ()

foreign import ccall "dynamic"
  mkFun :: FunPtr RevFun -> RevFun

callRevFun :: RevFun -> String -> String
callRevFun f s = unsafePerformIO $ withCAStringLen s $ \(cs, len) -> do
  allocaBytes len $ \buf -> do
    f buf cs (fromIntegral len)
    peekCAStringLen (buf, len)

getReverse :: IO (String -> String)
getReverse = do
  lib <- dlopen ("libcrypto" ++ dlSuffix) [RTLD_LAZY]
  fun <- dlsym lib "BUF_reverse"
  return $ callRevFun $ mkFun fun

main = do
  x <- try getReverse
  let (msg, rev) =
        case x of
          Left e -> (ioeGetErrorString e ++ "; using fallback", reverse)
          Right f -> ("Using BUF_reverse from OpenSSL", f)
  putStrLn msg
  putStrLn $ rev "a man a plan a canal panama"
