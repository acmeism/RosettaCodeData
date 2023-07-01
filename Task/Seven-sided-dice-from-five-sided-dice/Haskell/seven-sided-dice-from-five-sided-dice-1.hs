import System.Random
import Data.List

sevenFrom5Dice = do
  d51 <- randomRIO(1,5) :: IO Int
  d52 <- randomRIO(1,5) :: IO Int
  let d7 = 5*d51+d52-6
  if d7 > 20 then sevenFrom5Dice
       else return $ 1 + d7 `mod` 7
