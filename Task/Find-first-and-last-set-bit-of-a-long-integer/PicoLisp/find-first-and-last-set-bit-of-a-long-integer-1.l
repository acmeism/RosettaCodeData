(de msb (N)
   (dec (length (bin (abs N)))) )

(de lsb (N)
   (length (stem (chop (bin N)) "1")) )
