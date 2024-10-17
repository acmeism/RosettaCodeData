program Happy_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Int;

type
  TIntegerDynArray = TArray<Integer>;

  TIntHelper = record helper for Integer
    function IsHappy: Boolean;
    procedure Next;
  end;

{ TIntHelper }

function TIntHelper.IsHappy: Boolean;
var
  cache: TIntegerDynArray;
  sum, n: integer;
begin
  n := self;
  repeat
    sum := 0;
    while n > 0 do
    begin
      sum := sum + (n mod 10) * (n mod 10);
      n := n div 10;
    end;
    if sum = 1 then
      exit(True);

    if cache.Has(sum) then
      exit(False);
    n := sum;
    cache.Add(sum);
  until false;
end;

procedure TIntHelper.Next;
begin
  inc(self);
end;

var
  count, n: integer;

begin
  n := 1;
  count := 0;
  while count < 8 do
  begin
    if n.IsHappy then
    begin
      count.Next;
      write(n, ' ');
    end;
    n.Next;
  end;
  writeln;
  readln;
end.
