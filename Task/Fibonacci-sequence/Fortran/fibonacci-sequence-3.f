      EXTERNAL IFIB
      CHARACTER*10 LINE
      PARAMETER ( LINE = '----------' )
      WRITE(*,900) 'N', 'F[N]', 'F[-N]'
      WRITE(*,900) LINE, LINE, LINE
      DO 1 N = 0, 10
        WRITE(*,901) N, IFIB(N), IFIB(-N)
    1 CONTINUE
  900 FORMAT(3(X,A10))
  901 FORMAT(3(X,I10))
      END
