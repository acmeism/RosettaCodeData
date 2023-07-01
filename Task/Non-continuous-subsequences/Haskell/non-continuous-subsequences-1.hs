action p x = if p x then succ x else x

fenceM p q s []     = guard (q s) >> return []
fenceM p q s (x:xs) = do
  (f,g) <- p
  ys <- fenceM p q (g s) xs
  return $ f x ys

ncsubseq = fenceM [((:), action even), (flip const, action odd)] (>= 3) 0
