derangements xs = loop xs xs
    where loop [] [] = [[]]
          loop (h:hs) xs = [x:ys | x <- xs, x /= h, ys <- loop hs (delete x xs)]
