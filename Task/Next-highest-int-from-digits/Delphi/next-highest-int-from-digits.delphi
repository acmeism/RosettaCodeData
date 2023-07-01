program Next_highest_int_from_digits;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections;

function StrToBytes(str: AnsiString): TArray<byte>;
begin
  SetLength(result, Length(str));
  Move(Pointer(str)^, Pointer(result)^, Length(str));
end;

function BytesToStr(bytes: TArray<byte>): AnsiString;
begin
  SetLength(Result, Length(bytes));
  Move(Pointer(bytes)^, Pointer(Result)^, Length(bytes));
end;

function Commatize(s: string): string;
begin
  var le := length(s);
  var i := le - 3;
  while i >= 1 do
  begin
    s := s.Substring(0, i) + ',' + s.Substring(i);
    inc(i, -3);
  end;
  Result := s;
end;

function Permute(s: string): TArray<string>;
var
  res: TArray<string>;
  b: string;

  procedure rc(np: Integer);
  begin
    if np = 1 then
    begin
      SetLength(res, Length(res) + 1);
      res[High(res)] := b;
      exit;
    end;

    var np1 := np - 1;
    var pp := length(b) - np1;
    rc(np1);
    for var i := pp downto 1 do
    begin
      var tmp := b[i + 1];
      b[i + 1] := b[i];
      b[i] := tmp;
      rc(np1);
    end;

    var w := b[1];
    delete(b, 1, 1);
    Insert(w, b, pp + 1);
  end;

begin
  if s.Length = 0 then
    exit;

  res := [];
  b := s;
  rc(length(b));
  result := res;
end;

procedure Algorithm1(nums: TArray<string>);
begin
  writeln('Algorithm 1');
  writeln('-----------');
  for var num in nums do
  begin
    var perms := permute(num);
    var le := length(perms);
    if le = 0 then
      Continue;

    TArray.Sort<string>(perms);
    var ix := 0;
    TArray.BinarySearch<string>(perms, num, ix);

    var next := '';
    if ix < le - 1 then
      for var i := ix + 1 to le - 1 do
        if perms[i] > num then
        begin
          next := perms[i];
          Break;
        end;
    if length(next) > 0 then
      writeln(format('%29s -> %s', [Commatize(num), Commatize(next)]))
    else
      writeln(format('%29s -> 0', [Commatize(num)]));
  end;
  writeln;
end;

procedure Algorithm2(nums: TArray<string>);
var
  ContinueMainFor: boolean;
begin

  writeln('Algorithm 2');
  writeln('-----------');

  for var num in nums do
  begin
    ContinueMainFor := false;
    var le := num.Length;
    if le = 0 then
      Continue;

    var b := StrToBytes(num);

    var max := b[le - 1];
    var mi := le - 1;
    for var i := le - 2 downto 0 do
    begin
      if b[i] < max then
      begin
        var min := max - b[i];
        for var j := mi + 1 to le - 1 do
        begin
          var min2 := b[j] - b[i];
          if (min2 > 0) and (min2 < min) then
          begin
            min := min2;
            mi := j;
          end;
        end;
        var tmp := b[i];
        b[i] := b[mi];
        b[mi] := tmp;
        var c := copy(b, i + 1, le);
        TArray.Sort<byte>(c);

        var next: string := BytesToStr(copy(b, 0, i + 1));
        next := next + BytesToStr(c);
        writeln(format('%29s -> %s', [Commatize(num), Commatize(next)]));
        ContinueMainFor := true;
        Break;
      end
      else if b[i] > max then
      begin
        max := b[i];
        mi := i;
      end;
    end;
    if ContinueMainFor then
      Continue;
    writeln(format('%29s -> 0', [Commatize(num)]));
  end;
end;

begin
  var nums: TArray<string> := ['0', '9', '12', '21', '12453', '738440',
    '45072010', '95322020'];
  algorithm1(nums); // exclude the last one

  SetLength(nums, Length(nums) + 1);
  nums[High(nums)] := '9589776899767587796600';

  algorithm2(nums); // include the last one
  {$IFNDEF UNIX}
  readln; {$ENDIF}
end.
