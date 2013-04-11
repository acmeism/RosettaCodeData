zeckendorf = "0":"1":[s++[d] |	s <- tail zeckendorf, d <- "01",
				last s /= '1' || d /= '1']

main = mapM putStrLn $ take 21 zeckendorf
