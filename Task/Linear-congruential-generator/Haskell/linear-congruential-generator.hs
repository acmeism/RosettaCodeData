bsd = tail . iterate (\n -> (n * 1103515245 + 12345) `mod` 2^31)
msr = map (`div` 2^16) . tail . iterate (\n -> (214013 * n + 2531011) `mod` 2^31)

main = do
	print $ take 10 $ bsd 0 -- can take seeds other than 0, of course
	print $ take 10 $ msr 0
