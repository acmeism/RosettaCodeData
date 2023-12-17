program SquFoF_console;

{$mode objfpc}{$H+}

uses SquFoF_utils;

type TResultKind =
  (rkPrelim, // a factor was found by the preliminary routine
   rkMain,   // a factor was found by the main algorithm
   rkFail);  // no factor was found
type TAlgoResult = record
  Kind : TResultKind;
  Mult : word;
  Factor : UInt64;
end;

// Preliminary to G-W algorithm. Returns D and S of the algorithm.
// Also returns a non-trivial factor if found, else returns factor = 1.
procedure GWPrelim( N : UInt64; // number to be factorized
                    m : word;   // multiplier
                    out D, S, factor : UInt64);
var
  sqflag : boolean;
begin
  D := m*N;
  sqflag := SquFoF_utils.IsSquare( D, S);
  if m = 1 then
    if sqflag then factor := S
              else factor := 1
  else
    factor := GCD( N,m);
end;

// Tries to factorize N by applying Gower-Wagstaff alsorithm to m*N.
function GW_with_multiplier( N : UInt64;
                             m : word) : TAlgoResult;
var
  D, S, P, P_prev, Q, L, B: Uint64;
  r : UInt64;
  i, j, k : integer;
  f, g : UInt64;
  sqrtD : double;
  endCycle : boolean;
// Queue is not much used, so make it a simple array.
type TQueueItem = record
  Left, Right : UInt64;
end;
const QUEUE_CAPACITY = 50; // as suggested by Gower & Wagstaff
var
  queue : array [0..QUEUE_CAPACITY - 1] of TQueueItem;
  queueCount : integer;
begin
  result.Mult := m;

// Filter out special cases (differs from Gower & Wagstaff). Note:
// (1) multiplier m is assumed to be squarefree;
// (2) if we proceed to the main algorithm, mN must not be square
//     (otherwise Q = 0 and division by Q causes an error).
  GWPrelim( N, m, {out} D, S, f);
  if f > 1 then begin
    result.Kind := rkPrelim;
    result.Factor := f;
    exit;
  end;
// Not special, proceed to main algorithm
  result.Kind := rkMain;
  result.Mult := m;
  result.Factor := 1;
  queueCount := 0; // Clear queue
  P := S;
  Q := 1;
  i := -1; // keep i same as in G & W; algo fails if i > B
  sqrtD := SquFoF_utils.FSqrt( D);
//  L := Trunc( 2.0*Sqrt( 2.0*sqrtD));
  L := Trunc( Sqrt( 2.0*sqrtD)); // as in Section 5.2 of G&W paper
  B := 2*L;

  // Start forward cycle
  endCycle := false;
  while not endCycle do begin
    // We update Q here, P at the end of the loop
    Q := (D - P*P) div Q;
    if (not Odd(i)) and SquFoF_utils.IsSquare( Q, r) then begin
      // Q is square for even i.
      // Possibly (?probably?) ends the forward cycle,
      //   but we need to inspect the queue first.
      endCycle := true;
      j := queueCount; // working backwards down the queue
      if r = 1 then begin // the method may fail
        while (j > 0) and (result.Kind <> rkFail) do begin
          dec( j);
          if queue[j].Left = 1 then result.Kind := rkFail;
        end;
        if result.Kind = rkFail then exit;
      end
      else begin // if r > 1
        while (j > 0) and (endCycle) do begin
          dec( j);
          if (queue[j].Left = r)
          and ((P - queue[j].Right) mod r = 0) then begin
              // Deleting up to the *last* item in the list that
              // satisfies the condition, Should it be the *first* ?
              // Delete queue items 0..j inclusive
            inc(j);  k := 0;
            while j < queueCount do begin
              queue[k] := queue[j];
              inc(j);  inc(k);
            end;
            queueCount := k;
            endCycle := false;
          end; // if
        end;
      end;
    end; // if i even and Q square
    if not endCycle then begin
      g := Q div SquFoF_utils.GCD( Q, 2*m);
      if g <= L then begin
        if queueCount < QUEUE_CAPACITY then begin
          with queue[queueCount] do begin
            Left := g;  Right := P mod g;
          end;
          inc( queueCount);
        end
        else begin // queue overflow, fail
          result.Kind := rkFail;
          exit;
        end;
      end;
      inc(i);
      if i > B then begin
        result.Kind := rkFail;
        exit;
      end;
    end;
    P := S - ((S + P) mod Q);
  end; // while not endCycle
  Assert( (D - P*P) mod r = 0); // optional check
  P := S - ((S + P) mod r);
  Q := r;
  // Start backward cycle
  endCycle := false;
  while not endCycle do begin
    P_prev := P;
    Q := (D - P*P) div Q;
    P := S - ((S + P) mod q);
    endCycle := (P = P_prev);
  end; // while not endCycle
  // Finished
  result.Factor := Q div SquFoF_utils.GCD( Q, 2*m);
end;

const NR_RC_VALUES = 28;
RC_VALUES : array [0..NR_RC_VALUES - 1] of UInt64 =
( 2501, 12851, 13289, 75301, 120787, 967009, 997417, 7091569, 13290059,
  42854447, 223553581, 2027651281, 11111111111, 100895598169, 1002742628021,
  60012462237239, 287129523414791, 9007199254740931, 11111111111111111,
  314159265358979323, 384307168202281507, 419244183493398773,
  658812288346769681, 922337203685477563, 1000000000000000127,
  1152921505680588799, 1537228672809128917, 4611686018427387877);

type TMultAndMaxN = record
  Mult : word;   // small multiplier
  MaxN : UInt64; // maximum N for that multiplier (N*multiplier < 2^64)
end;
const NR_MULTIPLIERS = 16;
const MULTIPLIERS : array [0..NR_MULTIPLIERS - 1] of TMultAndMaxN =
((Mult:    1; MaxN: 18446744073709551615),
 (Mult:    3; MaxN:  6148914691236517205),
 (Mult:    5; MaxN:  3689348814741910323),
 (Mult:    7; MaxN:  2635249153387078802),
 (Mult:   11; MaxN:  1676976733973595601),
 (Mult:   15; MaxN:  1229782938247303441),
 (Mult:   21; MaxN:   878416384462359600),
 (Mult:   33; MaxN:   558992244657865200),
 (Mult:   35; MaxN:   527049830677415760),
 (Mult:   55; MaxN:   335395346794719120),
 (Mult:   77; MaxN:   239568104853370800),
 (Mult:  105; MaxN:   175683276892471920),
 (Mult:  165; MaxN:   111798448931573040),
 (Mult:  231; MaxN:    79856034951123600),
 (Mult:  385; MaxN:    47913620970674160),
 (Mult: 1155; MaxN:    15971206990224720));

function GowerWagstaff( N : UInt64) : TAlgoResult;
var
 j : integer;
begin
 j := 0;
 result.Kind := rkFail;
 while (result.Kind = rkFail)
   and (j < NR_MULTIPLIERS)
   and (N <= MULTIPLIERS[j].MaxN) do
 begin
   result := GW_with_multiplier( N, MULTIPLIERS[j].Mult);
   if result.Kind = rkFail then inc(j);
 end;
end;

// Main program
var
  j : integer;
  ar : TAlgoResult;
  kindStr : string;
  N, cofactor : UInt64;
begin
  WriteLn( '              Number Mult  M/P    Factorization');
  for j := 0 to NR_RC_VALUES - 1 do begin
    N := RC_VALUES[j];
    ar := GowerWagstaff( N);
    if ar.Kind = rkFail then
      WriteLn( N:20, '  No factor found')
    else begin
      case ar.Kind of
        rkPrelim: kindStr := 'Prelim';
        rkMain : kindStr := 'Main  ';
      end;
      cofactor := N div ar.Factor;
      Assert( cofactor * ar.Factor = N); // check that all has gone well
      WriteLn( N:20, ar.Mult:5, '  ',
               kindStr:6, ' ', ar.Factor, ' * ', cofactor);
    end;
  end;
end.

unit SquFoF_utils;

{$mode objfpc}{$H+}

interface

// Returns floating-point square root of 64-bit unsigned integer.
function FSqrt( x : UInt64) : double;

// Returns whether a 64-bit unsigned integer is a perfect square.
// In either case, returns floor(sqrt(x)) in the out parameter.
function IsSquare( x : UInt64; out iroot : UInt64) : boolean;

// Returns g.c.d. of 64-bit and 16-bit unsigned integer.
function GCD( u : UInt64; x : word) : word;

implementation

function FSqrt( x : UInt64) : double;
// Both Free Pascal and Delphi 7 seem unreliable when casting
// a 64-bit integer to floating point. We use a workaround.
type TSplitUint64 = packed record case boolean of
  true:  (All : UInt64);
  false: (Lo, Hi : longword); // longword is 32-bit unsigned
end;
var
  temp : TSplitUInt64;
begin
  temp.All := x;
  result := Sqrt( 1.0*temp.Lo + 4294967296.0*temp.Hi);
end;

// Based on Rosetta Code ISqrt, solution for Modula-2.
// Trunc of the f.p. square root won't do, bacause of rounding errors..
function IsSquare( x : UInt64; out iroot : UInt64) : boolean;
var
  Xdiv4, q, r, s, z : UInt64;
begin
  Xdiv4 := X shr 2;
  q := 1;
  while q <= Xdiv4 do q := q shl 2;
  z := x;
  r := 0;
  repeat
    s := q + r;
    r := r shr 1;
    if z >= s then begin
      z := z - s;
      r := r + q;
    end;
    q := q shr 2;
  until q = 0;
  iroot := r;
  result := (z = 0);
end;

function GCD( u : UInt64; x : word) : word;
var
  y, t : word;
begin
  y := u mod x;
  while y <> 0 do begin
    t := x mod y;
    x := y;
    y := t;
  end;
  result := x;
end;
end.
