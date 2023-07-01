REPORT R NO STANDARD PAGE HEADING LINE-SIZE 67.
DATA:A(440),B,C,N(3) TYPE N,I TYPE I,S.
A+000 = 'REPORT R NO STANDARD PAGE HEADING LINE-SIZE 6\7.1DATA:A'.
A+055 = '(440),B,C,N(\3) TYPE N,I TYPE I,S.?1DO 440 TIMES.3C = A'.
A+110 = '+I.3IF B = S.5IF C CA `\\\?\1\3\5\7`.7B = C.5ELSEIF C ='.
A+165 = ' `\``.7WRITE ```` NO-GAP.5ELSE.7WRITE C NO-GAP.5ENDIF.3'.
A+220 = 'ELSEIF B = `\\`.5WRITE C NO-GAP.5B = S.3ELSEIF B = `\?`'.
A+275 = '.5DO 8 TIMES.7WRITE:/ `A+` NO-GAP,N,`= ``` NO-GAP,A+N(\'.
A+330 = '5\5) NO-GAP,```.`.7N = N + \5\5.5ENDDO.5B = C.3ELSE.5WR'.
A+385 = 'ITE AT /B C NO-GAP.5B = S.3ENDIF.3I = I + \1.1ENDDO.   '.
DO 440 TIMES.
  C = A+I.
  IF B = S.
    IF C CA '\?1357'.
      B = C.
    ELSEIF C = '`'.
      WRITE '''' NO-GAP.
    ELSE.
      WRITE C NO-GAP.
    ENDIF.
  ELSEIF B = '\'.
    WRITE C NO-GAP.
    B = S.
  ELSEIF B = '?'.
    DO 8 TIMES.
      WRITE:/ 'A+' NO-GAP,N,'= ''' NO-GAP,A+N(55) NO-GAP,'''.'.
      N = N + 55.
    ENDDO.
    B = C.
  ELSE.
    WRITE AT /B C NO-GAP.
    B = S.
  ENDIF.
  I = I + 1.
ENDDO.
