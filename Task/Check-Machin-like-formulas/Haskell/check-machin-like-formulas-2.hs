import Data.Ratio

-- Private type. Do not use outside of the tans function
newtype Tan a = Tan a deriving (Eq, Show)
instance Fractional a => Num (Tan a) where
  _ + _ = undefined
  Tan a * Tan b = Tan $ (a + b) / (1 - a * b)
  negate _ = undefined
  abs _ = undefined
  signum _ = undefined
  fromInteger 1 = Tan 0 -- identity for the (*) above
  fromInteger _ = undefined
instance Fractional a => Fractional (Tan a) where
  fromRational _ = undefined
  recip (Tan f) = Tan (-f) -- inverse for the (*) above

tans :: (Integral a, Fractional b) => [(a, b)] -> b
tans xs = x where
  Tan x = product [Tan f ^^ coef | (coef,f) <- xs]

machins = [
	[(1, 1%2), (1, 1%3)],
	[(2, 1%3), (1, 1%7)],
	[(12, 1%18), (8, 1%57), (-5, 1%239)],
	[(88, 1%172), (51, 1%239), (32 , 1%682), (44, 1%5357), (68, 1%12943)]]

not_machin = [(88, 1%172), (51, 1%239), (32 , 1%682), (44, 1%5357), (68, 1%12944)]

main = do
	putStrLn "Machins:"
	mapM_ (\x -> putStrLn $ show (tans x) ++ " <-- " ++ show x) machins

	putStr "\nnot Machin: "; print not_machin
	print (tans not_machin)
