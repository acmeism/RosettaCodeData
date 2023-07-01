import Control.Exception (catch, evaluate, ErrorCall)
import System.IO.Unsafe (unsafePerformIO)
import Prelude hiding (catch)
import Control.DeepSeq (NFData, deepseq)

scoopError :: (NFData a) => a -> Either String a
scoopError x = unsafePerformIO $ catch right left
  where right = deepseq x $ return $ Right x
        left e = return $ Left $ show (e :: ErrorCall)

safeHead :: (NFData a) => [a] -> Either String a
safeHead = scoopError . head

main = do
  print $ safeHead ([] :: String)
  print $ safeHead ["str"]
