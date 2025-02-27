program LeonardoNumbers;

  procedure WriteLeonardoNums(L0, L1: longint; Sum: integer;
    Lmt: integer; What: string);
  var
    I: integer;
    Tmp: longint;
  begin
    WriteLn(What, ' (', L0, ', ', L1, ', ', Sum, '):');
    if Lmt >= 1 then
      Write(L0, ' ');
    if Lmt >= 2 then
      Write(L1, ' ');
    for I := 3 to Lmt do
    begin
      Write(L0 + L1 + Sum, ' ');
      Tmp := L0;
      L0 := L1;
      L1 := Tmp + L1 + Sum;
    end;
    WriteLn;
  end;

begin
  WriteLeonardoNums(1, 1, 1, 25, 'Leonardo numbers');
  WriteLeonardoNums(0, 1, 0, 25, 'Fibonacci numbers');
  ReadLn;
end.
