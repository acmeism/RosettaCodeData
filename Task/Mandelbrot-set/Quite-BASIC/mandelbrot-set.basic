1000 REM Mandelbrot Set Project
1010 REM Quite BASIC Math Project
1015 REM 'http://www.quitebasic.com/prj/math/mandelbrot/
1020 REM ------------------------
1030 CLS
1040 PRINT "This program plots a graphical representation of the famous Mandelbrot set.  It takes a while to finish so have patience and don't have too high expectations;  the graphics resolution is not very high on our canvas."
2000 REM Initialize the color palette
2010 GOSUB 3000
2020 REM L is the maximum iterations to try
2030 LET L = 100
2040 FOR I = 0 TO 100
2050 FOR J = 0 TO 100
2060 REM Map from pixel coordinates (I,J) to math (U,V)
2060 LET U = I / 50 - 1.5
2070 LET V = J / 50 - 1
2080 LET X = U
2090 LET Y = V
2100 LET N = 0
2110 REM Inner iteration loop starts here
2120 LET R = X * X
2130 LET Q = Y * Y
2140 IF R + Q > 4 OR N >= L THEN GOTO 2190
2150 LET Y = 2 * X * Y + V
2160 LET X = R - Q + U
2170 LET N = N + 1
2180 GOTO 2120
2190 REM Compute the color to plot
2200 IF N < 10 THEN LET C = "black" ELSE LET C = P[ROUND(8 * (N-10) / (L-10))]
2210 PLOT I, J, C
2220 NEXT J
2230 NEXT I
2240 END
3000 REM Subroutine -- Set up Palette
3010 ARRAY P
3020 LET P[0] = "black"
3030 LET P[1] = "magenta"
3040 LET P[2] = "blue"
3050 LET P[3] = "green"
3060 LET P[4] = "cyan"
3070 LET P[5] = "red"
3080 LET P[6] = "orange"
3090 LET P[7] = "yellow"
3090 LET P[8] = "white"
3100 RETURN
