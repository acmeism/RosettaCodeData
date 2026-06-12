Program DaysBetweenDates;
{$mode ObjFPC}{$H+}

Uses dateutils,strutils;

Type Tarr = array of array Of string;

Const lst : Tarr = (('1902-01-01','1968-12-25'),('2019-01-01','2019-01-02'),
                    ('2019-01-02','2019-01-01'),('2019-01-01','2019-03-01'),
                    ('2020-01-01','2020-03-01'),('1995-11-21','1995-11-21'),
                    ('2090-01-01','2098-12-25'),('1967-02-23','2024-03-21'));

Function strtodate(str : String) : tdatetime;
Begin
  result := ScanDateTime('YYYYMMDD', DelChars(str, '-'));
End;

Var arr : array of string;
  DaysBetw : integer;
Begin
  For arr In lst Do
    Begin
      DaysBetw := DaysBetween(strtodate(arr[0]),strtodate(arr[1]));
      writeln(arr[0],' - ',arr[1],' -> ',DaysBetw);
    End;
End.
