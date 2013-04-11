10  HGR2
20  XC = -0.5        : REM CENTER COORD X
30  YC = 0           : REM   "      "   Y
40  S = 2            : REM SCALE
45  IT = 20          : REM ITERATIONS
50  XR = S * 4 / 3   : REM TOTAL RANGE OF X
60  YR = S           : REM   "     "   "  Y
70  X0 = XC - (XR/2) : REM MIN VALUE OF X
80  X1 = XC + (XR/2) : REM MAX   "   "  X
90  Y0 = YC - (YR/2) : REM MIN   "   "  Y
100 Y1 = YC - (YR/2) : REM MAX   "   "  Y
110 XM = XR / 279    : REM SCALING FACTOR FOR X
120 YM = YR / 191    : REM    "      "     "  Y
130 FOR YI = 0 TO 3  : REM INTERLEAVE
140   FOR YS = 0+YI TO 188+YI STEP 4 : REM Y SCREEN COORDINATE
145   HCOLOR=3 : HPLOT 0,YS TO 279,YS
150     FOR XS = 0 TO 278 STEP 2     : REM X SCREEN COORDINATE
170       X = XS * XM + X0  : REM TRANSL SCREEN TO TRUE X
180       Y = YS * YM + Y0  : REM TRANSL SCREEN TO TRUE Y
190       ZX = 0
200       ZY = 0
210       XX = 0
220       YY = 0
230       FOR I = 0 TO IT
240         ZY = 2 * ZX * ZY + Y
250         ZX = XX - YY + X
260         XX = ZX * ZX
270         YY = ZY * ZY
280         C = IT-I
290         IF XX+YY >= 4 GOTO 301
300       NEXT I
301       IF C >= 8 THEN C = C - 8 : GOTO 301
310       HCOLOR = C : HPLOT XS, YS TO XS+1, YS
320     NEXT XS
330   NEXT YS
340 NEXT YI
