Program expdigitsums;

{$APPTYPE CONSOLE}

Uses
  System.Sysutils,
  System.Generics.Collections,
  Velthuis.Bigintegers;

Function Digital_sum(J: Biginteger): Integer;
Var
  Temp: String;
  I: Integer;
Begin
  Result := 0;
  Temp := J.Tostring;
  For I := 1 To Length(Temp) Do
    Result := Result + Ord(Temp[I]) - Ord('0');
End;

Procedure Exp_digit_sums(Cnt, Min_ways, Max_power: Integer);
Type
  Power = Record
    A, B: Integer;
  End;

Var
  Count, X: Integer;
  Pw: Biginteger;
  List: Tlist<Power>;
  Ppower: Power;

Begin
  List := Tlist<Power>.Create;
  Count := 0;
  X := 1;
  While Count < Cnt Do
  Begin

    Inc(X);
    For Var I := 2 To Max_power Do
    Begin
      Pw := Biginteger.Pow(X, I);
      If X = Digital_sum(Pw) Then
      Begin
        Ppower.A := X;
        Ppower.B := I;
        List.Add(Ppower);
      End;
    End;
    If List.Count >= Min_ways Then
    Begin
      Inc(Count);
      For Ppower In List Do
        Write(Ppower.A, '^', Ppower.B, '   ');
      Writeln;
    End;
    List.Clear;
  End;
End;

Begin
  Writeln('First twenty-five integers that are equal to the digital sum of that integer raised to some power:');
  Exp_digit_sums(25, 1, 100);
  Writeln;
  Writeln('First thirty that satisfy that condition in three or more ways:');
  Exp_digit_sums(30, 3, 500);
  Readln;
End..
