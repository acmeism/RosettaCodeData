import Data.List
import Control.Monad
import Control.Arrow
import Data.Maybe

states=" Ht."
shiftS=" t.."

borden bc xs = bs: (map (\x -> bc:(x++[bc])) xs) ++ [bs]
   where r = length $ head xs
         bs = replicate (r+2) bc

take3x3 = ap ((.). taken. length) (taken. length. head) `ap` borden '*'
   where taken n =  transpose. map (take n.map (take 3)).map tails

nwState xs | e =='.' && noH>0 && noH<3 = 'H'
           | otherwise = shiftS !! (fromJust $ elemIndex e states)
   where e = xs!!1!!1
         noH = length $ filter (=='H') $ concat xs

runCircuit = iterate (map(map nwState).take3x3)
