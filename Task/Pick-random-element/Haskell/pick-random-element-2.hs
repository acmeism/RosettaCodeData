import Data.Random
import Data.Random.Source.DevRandom
import Data.Random.Extras

x <- runRVar (choice [1 2 3]) DevRandom
