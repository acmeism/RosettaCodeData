DO i = 2, SIZE(a)
   j = i - 1
   DO WHILE (j>=1 .AND. a(j) > a(i))
      j = j - 1
   END DO
   a(j+1:i) = cshift(a(j+1:i),-1)
END DO
