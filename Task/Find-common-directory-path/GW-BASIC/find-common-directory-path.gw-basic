10 REM All GOTO statements can be replaced with EXIT FOR in newer BASICs.

110 X$ = "/home/user1/tmp/coverage/test"
120 Y$ = "/home/user1/tmp/covert/operator"
130 Z$ = "/home/user1/tmp/coven/members"

150 A = LEN(X$)
160 IF A > LEN(Y$) THEN A = LEN(Y$)
170 IF A > LEN(Z$) THEN A = LEN(Z$)
180 FOR L0 = 1 TO A
190     IF MID$(X$, L0, 1) <> MID$(Y$, L0, 1) THEN GOTO 210
200 NEXT
210 A = L0 - 1

230 FOR L0 = 1 TO A
240     IF MID$(X$, L0, 1) <> MID$(Z$, L0, 1) THEN GOTO 260
250 NEXT
260 A = L0 - 1

280 IF MID$(X$, L0, 1) <> "/" THEN
290     FOR L0 = A TO 1 STEP -1
300        IF "/" = MID$(X$, L0, 1) THEN GOTO 340
310     NEXT
320 END IF

340 REM Task description says no trailing slash, so...
350 A = L0 - 1
360 P$ = LEFT$(X$, A)
370 PRINT "Common path is '"; P$; "'"
