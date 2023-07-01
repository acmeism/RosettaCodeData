      SUBROUTINE FOLD(t,F,i,ist,lst)
       INTEGER t
       BYNAME F
        DO i = ist,lst
          t = F
        END DO
      END SUBROUTINE FOLD      !Result in temp.

      temp = a(1); CALL FOLD(temp,temp*a(i),i,2,N)
