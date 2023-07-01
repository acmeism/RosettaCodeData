import math, sequtils

echo "5^3^2 =   ", 5^3^2
echo "(5^3)^2 = ", (5^3)^2
echo "5^(3^2) = ", 5^(3^2)
echo "foldl([5, 3, 2], a^b) = ", foldl([5, 3, 2], a^b)
echo "foldr([5, 3, 2], a^b) = ", foldr([5, 3, 2], a^b)
