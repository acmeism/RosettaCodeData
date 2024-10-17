program Superpermutation_minimisation;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  Max = 12;

var
  super: ansistring;
  pos: Integer;
  cnt: TArray<Integer>;

function factSum(n: Integer): Uint64;
begin
  var s: Uint64 := 0;
  var f := 1;
  var x := 0;

  while x < n do
  begin
    inc(x);
    f := f * x;
    inc(s, f);
  end;

  Result := s;
end;

function r(n: Integer): Boolean;
begin
  if n = 0 then
    exit(false);

  var c := super[pos - n];

  dec(cnt[n]);

  if cnt[n] = 0 then
  begin
    cnt[n] := n;
    if not r(n - 1) then
      exit(false);
  end;
  super[pos] := c;
  inc(pos);
  result := true;
end;

procedure SuperPerm(n: Integer);
begin
  var pos := n;
  var le: Uint64 := factSum(n);
  SetLength(super, le);

  for var i := 0 to n do
    cnt[i] := i;

  for var i := 1 to n do
    super[i] := ansichar(i + ord('0'));

  while r(n) do
    ;
end;

begin
  SetLength(cnt, max);

  for var n := 0 to max - 1 do
  begin
    write('superperm(', n: 2, ') ');
    SuperPerm(n);
    writeln('len = ', length(super));
  end;
  {$IFNDEF UNIX}   readln; {$ENDIF}
end.
