program HeapSortDemo;

{$mode objfpc}{$h+}{$b-}

procedure HeapSort(var a: array of Integer);
  procedure SiftDown(Root, Last: Integer);
  var
    Child, Tmp: Integer;
  begin
    while Root * 2 + 1 <= Last do begin
      Child := Root * 2 + 1;
      if (Child + 1 <= Last) and (a[Child] < a[Child + 1]) then
        Inc(Child);
      if a[Root] < a[Child] then begin
        Tmp := a[Root];
        a[Root] := a[Child];
        a[Child] := Tmp;
        Root := Child;
      end else exit;
    end;
  end;
var
  I, Tmp: Integer;
begin
  for I := Length(a) div 2 downto 0 do
    SiftDown(I, High(a));
  for I := High(a) downto 1 do begin
    Tmp := a[0];
    a[0] := a[I];
    a[I] := Tmp;
    SiftDown(0, I - 1);
  end;
end;

procedure PrintArray(const Name: string; const A: array of Integer);
var
  I: Integer;
begin
  Write(Name, ': [');
  for I := 0 to High(A) - 1 do
    Write(A[I], ', ');
  WriteLn(A[High(A)], ']');
end;

var
  a1: array[-7..5] of Integer = (-34, -20, 30, 13, 36, -10, 5, -25, 9, 19, 35, -50, 29);
  a2: array of Integer = (-9, 42, -38, -5, -38, 0, 0, -15, 37, 7, -7, 40);
begin
  HeapSort(a1);
  PrintArray('a1', a1);
  HeapSort(a2);
  PrintArray('a2', a2);
end.
