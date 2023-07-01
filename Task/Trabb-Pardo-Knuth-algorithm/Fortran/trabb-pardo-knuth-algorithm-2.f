C     THE TPK ALGORITH - FORTRAN I - 1957                               TPK00010
      FTPKF(X)=SQRTF(ABSF(X))+5.0*X**3                                  TPK00020
      DIMENSION A(11)                                                   TPK00030
      READ 100,A                                                        TPK00040
 100  FORMAT(6F12.4/)                                                   TPK00050
      DO 3 I=1,11                                                       TPK00060
      J=12-I                                                            TPK00070
      Y=FTPKF(A(J))                                                     TPK00080
      IF (Y-400.0)2,2,1                                                 TPK00090
   1  PRINT 301,I,A(J)                                                  TPK00100
 301  FORMAT(I10,F12.7,18H *** TOO LARGE ***)                           TPK00110
      GO TO 10                                                          TPK00120
   2  PRINT 302,I,A(J),Y                                                TPK00130
 302  FORMAT(I10,2F12.7)                                                TPK00140
   3  CONTINUE                                                          TPK00150
      STOP 0                                                            TPK00160
