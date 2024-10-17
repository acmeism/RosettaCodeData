program Quickselect_algorithm;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function quickselect(list: TArray<Integer>; k: Integer): Integer;

  procedure Swap(i, j: Integer);
  var
    tmp: Integer;
  begin
    tmp := list[i];
    list[i] := list[j];
    list[j] := tmp;
  end;

begin
  repeat
    var px := length(list) div 2;
    var pv := list[px];
    var last := length(list) - 1;

    Swap(px, last);
    var i := 0;
    for var j := 0 to last - 1 do
      if list[j] < pv then
      begin
        swap(i, j);
        inc(i);
      end;

    if i = k then
      exit(pv);

    if k < i then
      delete(list, i, length(list))
    else
    begin
      Swap(i, last);
      delete(list, 0, i + 1);
      dec(k, i + 1);
    end;
  until false;
end;

begin
  var i := 0;

  while True do
  begin
    var v: TArray<Integer> := [9, 8, 7, 6, 5, 0, 1, 2, 3, 4];
    if i = length(v) then
      Break;
    Writeln(quickselect(v, i));
    inc(i);
  end;
  Readln;
end.
