import Data.List

teststring = "In olden times when wishing still helped one, there lived a king"
	++" whose daughters were all beautiful, but the youngest was so beautiful"
	++" that the sun itself, which has seen so much, was astonished whenever"
	++" it shone in her face.  Close by the king's castle lay a great dark"
	++" forest, and under an old lime-tree in the forest was a well, and when"
	++" the day was very warm, the king's child went out into the forest and"
	++" sat down by the side of the cool fountain, and when she was bored she"
	++" took a golden ball, and threw it up on high and caught it, and this"
	++" ball was her favorite plaything."

wwrap'' _ [] = []
wwrap'' i ss = (\(a,b) -> a : wwrap'' i b)
	$ last . filter ((<=i) . length . unwords . fst)
	$ zip (inits ss) (tails ss)

wwrap :: Int -> String -> String
wwrap i = unlines . map unwords . wwrap'' i . words . concat . lines

main = putStrLn $ wwrap 80 teststring
