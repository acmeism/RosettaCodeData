USES CRT;
BEGIN
  SETWINDOWSIZE(132, 25);
  VAR MNTH:=|'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'|;
  GOTOXY(57, 1);
  PRINT('[SNOOPY]');
  GOTOXY(65, 2);
  PRINT('1969');
  VAR DW:=2;
  FOREACH VAR M IN MNTH INDEX I DO BEGIN
    VAR (X, Y):=(I MOD 6 * 22, 3 + I DIV 6 * 9);
    GOTOXY(X+1, Y+1);
    PRINT('MO TU WE TH FR SA SU');
    GOTOXY(X + 11 - M.Length DIV 2, Y);
    PRINT(M);
    VAR DAYS:=(I IN |3,5,8,10| ? 30 : I=1 ? 28 : 31);
    Y+=2;
    X+=1;
    FOR VAR D:=1 TO DAYS DO BEGIN
      GOTOXY(X + DW*3, Y);
      WRITE(D:2);
      DW:=(DW+1) MOD 7;
      IF DW=0 THEN Y+=1;
    end;
  end;
  GOTOXY(1,21);
END.