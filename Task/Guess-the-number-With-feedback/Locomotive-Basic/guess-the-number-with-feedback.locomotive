10 CLS:RANDOMIZE TIME
20 PRINT "Please specify lower and upper limits":guess=0
30 INPUT "  (must be positive integers) :", first, last
40 IF first<1 OR last<1 THEN 20
50 num=INT(RND*(last-first+1)+first)
60 WHILE num<>guess
70 INPUT "Your guess? ", guess
80 IF guess<num THEN PRINT "too small!"
90 IF guess>num THEN PRINT "too large!"
100 WEND
110 INPUT "That's correct! Another game (y/n)? ", yn$
120 IF yn$="y" THEN 20
