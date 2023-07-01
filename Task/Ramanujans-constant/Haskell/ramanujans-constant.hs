import Control.Monad (forM_)
import Data.Number.CReal (CReal, showCReal)
import Text.Printf (printf)

ramfun :: CReal -> CReal
ramfun x = exp (pi * sqrt x)

-- Ramanujan's constant.
ramanujan :: CReal
ramanujan = ramfun 163

-- The last four Heegner numbers.
heegners :: [Int]
heegners = [19, 43, 67, 163]

-- The absolute distance to the nearest integer.
intDist :: CReal -> CReal
intDist x = abs (x - fromIntegral (round x))

main :: IO ()
main = do
  let n = 35
  printf "Ramanujan's constant: %s\n\n" (showCReal n ramanujan)
  printf "%3s %34s%20s%s\n\n" " h " "e^(pi*sqrt(h))" "" " Dist. to integer"
  forM_ heegners $ \h ->
    let r = ramfun (fromIntegral h)
        d = intDist r
    in printf "%3d %54s %s\n" h (showCReal n r) (showCReal 15 d)
