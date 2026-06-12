program Sum_of_divisors;
{$IFDEF WINDOWS}}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$IFDEF DELPHI}
uses
  System.SysUtils;
{$ENDIF}

function DivisorSum(n: Cardinal): Cardinal;
//check up to i*i= n
var
  i,quot,total: Cardinal;
begin
  total :=n+1;
  i := 2;
  repeat
    quot := n div i;
    //i >= sqrt(n) reached
    if quot <= i then
      BREAK;
    // n mod i = 0
    if quot*i = n then
      inc(total,i+quot);
    inc(i);
  until false;
  if i*i = n then
    inc(total,i);
  DivisorSum := total;
end;

const
  limit = 100;
var
  res,
  n :  cardinal;

begin
  writeln('Sum of divisors for the first ', limit, ' positive integers:');
  for  n := 1 to limit do
  begin
    res := divisorSum(n);
    Write(res: 4);
    if n mod 20 = 0 then
      writeln;
  end;
{$IFDEF WINDOWS}}
  readln;
{$ENDIF}
end.
