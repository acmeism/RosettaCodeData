import Control.Monad.Trans.Writer
import Control.Monad ((>=>))

loggingVersion :: (a -> b) -> c -> a -> Writer c b
loggingVersion f log x = writer (f x, log)

logRoot = loggingVersion sqrt "obtained square root, "
logAddOne = loggingVersion (+1) "added 1, "
logHalf = loggingVersion (/2) "divided by 2, "

main = print . runWriter $ (logRoot >=> logAddOne >=> logHalf) 5
