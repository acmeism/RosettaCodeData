import System.Process (callProcess) -- From “process” library

say text = callProcess "espeak" ["--", text]

main = say "This is an example of speech synthesis."
