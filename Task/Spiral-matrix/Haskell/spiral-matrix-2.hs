import Data.List
import Control.Applicative
counts = tail . reverse . concat . map (replicate 2) . enumFromTo 1
values = cycle . ((++) <$> map id <*> map negate) . (1 :) . (: [])
grade = map snd . sort . flip zip [0..]
copies = grade . scanl1 (+) . concat . map (uncurry replicate) . (zip <$> counts <*> values)
parts = (<*>) take $ (.) <$> (map . take) <*> (iterate . drop) <*> copies
disp = (>> return ()) . mapM (putStrLn . intercalate " " . map show) . parts
main = disp 5
