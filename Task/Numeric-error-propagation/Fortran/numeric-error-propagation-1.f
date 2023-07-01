      PROGRAM CALCULATE	!A distance, with error propagation.
      REAL X1, Y1, X2, Y2	!The co-ordinates.
      REAL X1E,Y1E,X2E,Y2E	!Their standard deviation.
      DATA X1, Y1 ,X2, Y2 /100., 50., 200.,100./	!Specified
      DATA X1E,Y1E,X2E,Y2E/  1.1, 1.2,  2.2, 2.3/	!Values.
      REAL DX,DY,D2,D,DXE,DYE,E	!Assistants.
      CHARACTER*1 C			!I'm stuck with code page 437 instead of 850.
      PARAMETER (C = CHAR(241))		!Thus ± does not yield this glyph on a "console" screen. CHAR(241) does.
      REAL SD	!This is an arithmetic statement function.
      SD(X,P,S) = P*ABS(X)**(P - 1)*S	!SD for X**P where SD of X is S
      WRITE (6,1) X1,C,X1E,Y1,C,Y1E,	!Reveal the points
     1            X2,C,X2E,Y2,C,Y2E	!Though one could have used an array...
    1 FORMAT ("Euclidean distance between two points:"/	!A heading.
     1 ("(",F5.1,A1,F3.1,",",F5.1,A1,F3.1,")"))		!Thus, One point per line.
      DX = (X1 - X2)			!X difference.
      DXE = SQRT(X1E**2 + X2E**2)	!SD for DX, a simple difference.
      DY = (Y1 - Y2)			!Y difference.
      DYE = SQRT(Y1E**2 + Y2E**2)	!SD for DY, (Y1 - Y2)
      D2 = DX**2 + DY**2		!The distance, squared.
      DXE = SD(DX,2,DXE)		!SD for DX**2
      DYE = SD(DY,2,DYE)		!SD for DY**2
      E = SQRT(DXE**2 + DYE**2)		!SD for their sum
      D = SQRT(D2)			!The distance!
      E = SD(D2,0.5,E)			!SD after the SQRT.
      WRITE (6,2) D,C,E			!Ahh, the relief.
    2 FORMAT ("Distance",F6.1,A1,F4.2)	!Sizes to fit the example.
      END	!Enough.
