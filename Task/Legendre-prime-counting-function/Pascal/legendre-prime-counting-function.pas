// Rosetta Code task "Legendre prime counting function".
// Solution for Free Pascal (Lazarus) or Delphi.
program LegendrePrimeCount;

{$IFDEF FPC} // Free Pascal
  {$MODE Delphi}
{$ELSE}      // Delphi
  {$APPTYPE CONSOLE}
{$ENDIF}

// Optimization needs to be on if the program is to finish in a reasonable
//   length of time. See "Comments on Task" on the Rosetta Code website.
{$DEFINE SIMPLE_OPTIMIZATION}

uses SysUtils, Types;

{-------------------------------------------------------------------
Function to return an array of primes up to the passed-in limit.
Uses a straightforward Eratosthenes sieve.
TIntegerDynArray must be 0-based. To be compatible with Rosetta Code,
the first prime 2 is at result[1], and result[0] is not used.
}
function FindPrimes( limit : integer) : Types.TIntegerDynArray;
var
  deleted : array of boolean;
  j, k, p, resultSize : integer;
begin
  if (limit < 2) then begin
    SetLength( result, 1);
    exit;
  end;
  SetLength( deleted, limit + 1); // 0..limit
  deleted[0] := true;
  for j := 1 to limit do deleted[j] := false;
  p := 2;
  while (p*p <= limit) do begin
    j := 2*p;
    while (j <= limit) do begin
      deleted[j] := true;
      inc( j, p);
    end;
    repeat inc(p)
    until (p > limit) or (not deleted[p]);
  end;
  resultSize := 0;
  for j := 0 to limit do
    if not deleted[j] then inc( resultSize);
  SetLength( result, resultSize);
  k := 0;
  for j := 0 to limit do begin
    if not deleted[j] then begin
      result[k] := j;
      inc(k);
    end;
  end;
end;

{-----------------------------------------------------------------------------
Function to count primes up to the passed-in limit, by Legendre's method.
Iterative, using a stack. Each item in the stack is a term phi(x,a) along
with a sign. If the top item on the stack can be evaluated easily, it is
popped off and its value is added to the result. Else the top item is
replaced by two items according to the formual in the task description.
}
function CountPrimes( n : integer) : integer;
type
  TPhiTerm = record
    IsNeg : boolean;
    x : integer;
    a : integer;
  end;
const
  STACK_SIZE = 100; // 10 is enough for n = 10^9
var
  primes : Types.TIntegerDynArray;
  nrPrimes : integer;
  stack : array [0..STACK_SIZE - 1] of TPhiTerm;
  sp : integer; // stack pointer, points to first free entry
  tos : TPhiTerm; // top of stack
begin
  primes := FindPrimes( Trunc( Sqrt( n + 0.5)));
  nrPrimes := Length( primes) - 1; // primes[0] is not used
  result := nrPrimes - 1; // initialize total
  // Push initial entry onto stack
  with stack[0] do begin
    IsNeg := false;
    x := n;
    a := nrPrimes;
  end;
  sp := 1;
  while sp > 0 do begin
    tos := stack[sp - 1];
{$IFDEF SIMPLE_OPTIMIZATION}
    // Using optimization described in "Comments on Task"
    if tos.x = 0 then begin // top of stack = 0
      dec(sp); // pop top of stack, no change to result
    end
    else if (tos.a > 0) and (tos.x < primes[tos.a]) then begin // top of stack = 1
      dec( sp); // pop top of stack, update result
      if tos.IsNeg then dec( result)
                   else inc( result);
    end
    else if tos.a = 0 then begin
{$ELSE}
    // Using only the task description, i.e. only phi(x,0) = x
    if tos.a = 0 then begin
{$ENDIF}
      dec( sp); // pop top of stack, update result
      if tos.IsNeg then dec( result, tos.x)
                   else inc( result, tos.x);
    end
    else begin
      // Replace top of stack by two items as in the task description,
      //    namely phi(x, a - 1) and -phi(x div primes[a], a - 1)
      if (sp >= STACK_SIZE) then
        raise SysUtils.Exception.Create( 'Legendre phi stack overflow');
      with stack[sp - 1] do begin
        IsNeg := tos.isNeg;
        x := tos.x;
        a := tos.a - 1;
      end;
      with stack[sp] do begin
        IsNeg := not tos.IsNeg;
        x := tos.x div primes[tos.a];
        a := tos.a - 1;
      end;
      inc(sp);
    end;
  end;
end;

{-----------------------------------------------------------
Main routine
}
var
  power, limit, count : integer;
begin
  WriteLn( 'Limit      Count');
  limit := 1;
  for power := 0 to 9 do begin
    if power > 0 then limit := 10*limit;
    count := CountPrimes( limit);
    WriteLn( SysUtils.Format( '10^%d  %10d', [power, count]))
  end;
end.
