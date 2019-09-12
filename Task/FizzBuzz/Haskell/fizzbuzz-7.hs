import Control.Monad.State
import Control.Monad.Trans
import Control.Monad.Writer

main = putStr $ execWriter $ mapM_ (flip execStateT True . fizzbuzz) [1..100]

fizzbuzz :: Int -> StateT Bool (Writer String) ()
fizzbuzz x = do
 when (x `mod` 3 == 0) $ tell "Fizz" >> put False
 when (x `mod` 5 == 0) $ tell "Buzz" >> put False
 get >>= (flip when $ tell $ show x)
 tell "\n"
