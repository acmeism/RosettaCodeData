import Data.Ratio
import Data.List (foldl')

tanPlus :: Fractional a => a -> a -> a
tanPlus a b = (a + b) / (1 - a * b)

tanEval :: (Integral a, Fractional b) => (a, b) -> b
tanEval (0,_) = 0
tanEval (coef,f)
	| coef < 0 = -tanEval (-coef, f)
	| odd coef = tanPlus f $ tanEval (coef - 1, f)
	| otherwise = tanPlus a a
		where a = tanEval (coef `div` 2, f)

tans :: (Integral a, Fractional b) => [(a, b)] -> b
tans = foldl' tanPlus 0 . map tanEval

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
