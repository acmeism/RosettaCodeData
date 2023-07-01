x = (sample(-1000.00:1000.00,100))
y = (sample(-1000.00:1000.00,length(x)))
cp = closest.pairs(x,y)
#cp = closestPair(x,y)
plot(x,y,pch=19,col='black',main="Closest Pair", asp=1)
points(cp["x1.x"],cp["y1.y"],pch=19,col='red')
points(cp["x2.x"],cp["y2.y"],pch=19,col='red')
#closest_pair_brute(x,y,T)

Performance
system.time(closest_pair_brute(x,y), gcFirst = TRUE)
Shortest path found =
 From:          (32,-987)
 To:            (25,-993)
 Distance:      9.219544

   user  system elapsed
   0.35    0.02    0.37

system.time(closest.pairs(x,y), gcFirst = TRUE)
The closest pair is:
        Point 1: 32.000, -987.000
        Point 2: 25.000, -993.000
        Distance: 9.220.

   user  system elapsed
   0.08    0.00    0.10

system.time(closestPair(x,y), gcFirst = TRUE)
The closest pair is:
        Point 1: 32, -987
        Point 2: 25, -993
        Distance: 9.219544

   user  system elapsed
   0.17    0.00    0.19
