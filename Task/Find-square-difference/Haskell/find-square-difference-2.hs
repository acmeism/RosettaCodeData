squareDifference n = n*n - (n-1)*(n-1)
findSmallestN limit = head (dropWhile (\n -> squareDifference n <= limit) [1..])
main = print (findSmallestN 1000)
