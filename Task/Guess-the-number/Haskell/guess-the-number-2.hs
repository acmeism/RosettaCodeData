import System.Random

main = randomRIO (1,10) >>= gameloop

gameloop :: Int -> IO ()
gameloop r = do	
	i <- fmap read getLine
	if i == r
	  then putStrLn "You got it!"
	  else putStrLn "Nope. Guess again." >> gameloop r
