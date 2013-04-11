import Data.Array

 mmult :: (Ix i, Num a) => Array (i,i) a -> Array (i,i) a -> Array (i,i) a
 mmult x y
   | x1 /= y0 || x1' /= y0'  = error "range mismatch"
   | otherwise               = array ((x0,y1),(x0',y1')) l
   where
     ((x0,x1),(x0',x1')) = bounds x
     ((y0,y1),(y0',y1')) = bounds y
     ir = range (x0,x0')
     jr = range (y1,y1')
     kr = range (x1,x1')
     l  = [((i,j), sum [x!(i,k) * y!(k,j) | k <- kr]) | i <- ir, j <- jr]
