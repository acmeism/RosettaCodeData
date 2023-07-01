10 REM Periodic table
20 DIM A(7), B(7)
30 GOSUB 200
40 FOR J% = 0 TO 9
50  READ ANUM%: GOSUB 400
60 NEXT J%
70 END
190 REM Set arrays A, B.
200 FOR I% = 0 TO 7: READ A(I%): NEXT I%
210 FOR I% = 0 TO 7: READ B(I%): NEXT I%
220 RETURN
390 REM Show row and column for element
400 I% = 7
410 WHILE A(I%) > ANUM%
420  I% = I% - 1
430 WEND
440 M% = ANUM% + B(I%)
450 R% = M% \ 18 + 1
460 C% = M% MOD 18 + 1
470 PRINT ANUM%;"->";R%;C%
480 RETURN
990 REM Data
1000 REM Arrays A, B.
1010 DATA  1,  2,  5, 13, 57, 72, 89, 104
1020 DATA -1, 15, 25, 35, 72, 21, 58,   7
1030 REM Example elements (atomic numbers).
1040 DATA 1, 2, 29, 42, 57, 58, 72, 89, 90, 103
