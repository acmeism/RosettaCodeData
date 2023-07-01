import           System.Random (getStdRandom, randomR)
import           Control.Monad (forever)

answers :: [String]
answers =
  [ "It is certain"
  , "It is decidedly so"
  , "Without a doubt"
  , "Yes, definitely"
  , "You may rely on it"
  , "As I see it, yes"
  , "Most likely"
  , "Outlook good"
  , "Signs point to yes"
  , "Yes"
  , "Reply hazy, try again"
  , "Ask again later"
  , "Better not tell you now"
  , "Cannot predict now"
  , "Concentrate and ask again"
  , "Don't bet on it"
  , "My reply is no"
  , "My sources say no"
  , "Outlook not so good"
  , "Very doubtful"]

main :: IO ()
main = do
  putStrLn "Hello. The Magic 8 Ball knows all. Type your question."
  forever $ do
    getLine
    n <- getStdRandom (randomR (0, pred $ length answers))
    putStrLn $ answers !! n
