import Data.List (transpose)
import Text.Printf (printf)

-- spiral is the first row plus a smaller spiral rotated 90 deg
spiral 0 _ _ = [[]]
spiral h w s = [[s .. s+w-1]] ++ rot90 (spiral w (h-1) (s+w))
	where rot90 = (map reverse).transpose

-- this is sort of hideous, someone may want to fix it
main = mapM_ (\row->mapM_ ((printf "%4d").toInteger) row >> putStrLn "") (spiral 10 9 1)
