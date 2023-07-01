MODULE DayOfWeek;
IMPORT DevCommanders, TextMappers, Dates, StdLog;

PROCEDURE XmastOnSun(s,e: INTEGER);
VAR
	i: INTEGER;
	d: Dates.Date;
BEGIN
	i := s;d.day := 25;d.month := 12;
	WHILE i < e DO
		d.year := i;
		IF Dates.DayOfWeek(d) = Dates.sunday THEN
			StdLog.Int(i);StdLog.Ln
		END;
		INC(i)
	END
END XmastOnSun;

PROCEDURE Do*;
VAR
	s: TextMappers.Scanner;
	r: ARRAY 2 OF INTEGER;
	i: INTEGER;
BEGIN
	s.ConnectTo(DevCommanders.par.text);
	s.SetPos(DevCommanders.par.beg);
	s.Scan;i := 0;
	WHILE ~s.rider.eot DO
		IF s.type = TextMappers.int THEN
			r[i] := s.int; INC(i)
		END;
		s.Scan
	END;
	XmastOnSun(r[0],r[1]);
END Do;

END DayOfWeek.
