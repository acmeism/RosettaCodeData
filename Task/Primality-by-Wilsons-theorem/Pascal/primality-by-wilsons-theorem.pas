program PrimesByWilson;
uses SysUtils;

(* Function to return whether 32-bit unsigned n is prime.
   Applies Wilson's theorem with full calculation of (n - 1)! modulo n. *)
function WilsonFullCalc( n : longword) : boolean;
var
  f, m : longword;
begin
  if n < 2 then begin
    result := false;  exit;
  end;
  f := 1;
  for m := 2 to n - 1 do begin
    f := (uint64(f) * uint64(m)) mod n; // typecast is needed
  end;
  result := (f = n - 1);
end;

(* Function to return whether 32-bit unsigned n is prime.
   Applies Wilson's theorem with a short cut. *)
function WilsonShortCut( n : longword) : boolean;
var
  f, g, h, m, m2inc, r : longword;
begin
  if n < 2 then begin
    result := false;  exit;
  end;
  (* Part 1: Factorial (modulo n) of floor(sqrt(n)) *)
  f := 1;
  m := 1;
  m2inc := 3; // (m + 1)^2 - m^2
  // Want to loop while m^2 <= n, but if n is close to 2^32 - 1 then least
  //   m^2 > n overflows 32 bits. Work round this by looking at r = n - m^2.
  r := n - 1;
  while r >= m2inc do begin
    inc(m);
    f := (uint64(f) * uint64(m)) mod n;
    dec( r, m2inc);
    inc( m2inc, 2);
  end;
 (* Part 2: Euclid's algorithm: at the end, h = HCF( f, n) *)
  h := n;
  while f <> 0 do begin
    g := h mod f;
    h := f;
    f := g;
  end;
  result := (h = 1);
end;

type TPrimalityTest = function( n : longword) : boolean;
procedure ShowPrimes( isPrime : TPrimalityTest;
                      minValue, maxValue : longword);
var
  n : longword;
begin
  WriteLn( 'Primes in ', minValue, '..', maxValue);
  for n := minValue to maxValue do
    if isPrime(n) then Write(' ', n);
  WriteLn;
end;

(* Main routine *)
begin
  WriteLn( 'By full calculation:');
  ShowPrimes( @WilsonFullCalc, 1, 100);
  ShowPrimes( @WilsonFullCalc, 1000, 1100);
  WriteLn; WriteLn( 'Using the short cut:');
  ShowPrimes( @WilsonShortCut, 1, 100);
  ShowPrimes( @WilsonShortCut, 1000, 1100);
  ShowPrimes( @WilsonShortCut, 4294967195, 4294967295 {= 2^32 - 1});
end.
