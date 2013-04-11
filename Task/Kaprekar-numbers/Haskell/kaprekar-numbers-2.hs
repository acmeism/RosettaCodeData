import Data.List
import Control.Monad (foldM)

primes = 2:3:filter isPrime (scanl (+) 5 $ cycle [2,4]) where
	isPrime x = all ((0 /=).(x `mod`)) $ takeWhile (\n->n * n <= x) primes

unitFactors n = map product $ group $ f n
		$ (takeWhile (\p -> p*p <= n) primes) where
	f 1 [] = []
	f n [] = [n]
	f n (p:ps)
		| n `mod` p == 0 = p : f (n`div`p) (p:ps)
		| otherwise = f n ps

-- all factors x of n where x and n/x are coprime
factors = foldM f 1 . unitFactors where
	f x a = [x, x*a]

-- modulo multiplication inverse: returns a where a x + b y == 1
inverse x y = if a < 0 then a + y else a where
	(a,b) = extEuclid x y
	extEuclid _ 0 = (1,0)
	extEuclid x y = (t, s - q * t) where
		(s, t) = extEuclid y r
		(q, r) = x `divMod` y

kaprekars base top = nub . sort . (concatMap kaps)
			-- this takeWhile is maybe questionable
			$ takeWhile (<= top * top `div` base^2)
			$ map (\x->base^x - 1) [1..]
	where
	kaps pb = filter (<=top) $ map f (factors pb) where
		f x	| x == pb = pb
			| otherwise = x * inverse x (pb `div` x)

main = mapM_ print $ kaprekars 10 10000000
