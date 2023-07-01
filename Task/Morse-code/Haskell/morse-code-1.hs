import System.IO
import MorseCode
import MorsePlaySox

-- Read standard input, converting text to Morse code, then playing the result.
-- We turn off buffering on stdin so it will play as you type.
main = do
  hSetBuffering stdin NoBuffering
  text <- getContents
  play $ toMorse text
