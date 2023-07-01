unit popcount;
{$IFDEF FPC}
   {$MODE DELPHI}
   {$OPTIMIZATION ON,ASMCSE,CSE,PEEPHOLE}
   {$Smartlink OFF}
{$ENDIF}

interface
  function popcnt(n:Uint64):integer;overload;
  function popcnt(n:Uint32):integer;overload;
  function popcnt(n:Uint16):integer;overload;
  function popcnt(n:Uint8):integer;overload;

implementation
const
//K1  = $0101010101010101;
  K33  = $3333333333333333;
  K55  = $5555555555555555;
  KF1 = $0F0F0F0F0F0F0F0F;
  KF2 = $00FF00FF00FF00FF;
  KF4 = $0000FFFF0000FFFF;
  KF8 = $00000000FFFFFFFF;
{
function popcnt64(n:Uint64):integer;
begin
  n := n- (n shr 1) AND K55;
  n := (n AND K33)+ ((n shr 2) AND K33);
  n := (n + (n shr 4)) AND KF1;
  n := (n*k1) SHR 56;
  result := n;
end;
}
function popcnt(n:Uint64):integer;overload;
// on Intel Haswell 2x faster for fpc 32-Bit
begin
  n := (n AND K55)+((n shr  1)  AND K55);
  n := (n AND K33)+((n shr  2)  AND K33);
  n := (n AND KF1)+((n shr  4)  AND KF1);
  n := (n AND KF2)+((n shr  8)  AND KF2);
  n := (n AND KF4)+((n shr 16)  AND KF4);
  n := (n AND KF8)+ (n shr 32);
  result := n;
end;

function popcnt(n:Uint32):integer;overload;
var
  c,b : NativeUint;
begin
  b := n;
  c := (b shr 1) AND NativeUint(K55);   b := (b AND NativeUint(K55))+C;
  c := ((b shr 2)  AND NativeUint(K33));b := (b AND NativeUint(K33))+C;
  c:= ((b shr 4)  AND NativeUint(KF1)); b := (b AND NativeUint(KF1))+c;
  c := ((b shr 8)  AND NativeUint(KF2));b := (b AND NativeUint(KF2))+c;
  c := b shr 16; b := (b AND NativeUint(KF4))+ C;
  result := b;
end;

function popcnt(n:Uint16):integer;overload;
var
  c,b : NativeUint;
begin
  b := n;
  c := (b shr 1) AND NativeUint(K55);  b := (b AND NativeUint(K55))+C;
  c :=((b shr 2)  AND NativeUint(K33)); b := (b AND NativeUint(K33))+C;
  c:= ((b shr 4)  AND NativeUint(KF1)); b := (b AND NativeUint(KF1))+c;
  c :=  b shr 8; b := (b AND NativeUint(KF2))+c;
  result := b;
end;

function popcnt(n:Uint8):integer;overload;
var
  c,b : NativeUint;
begin
  b := n;
  c := (b shr 1) AND NativeUint(K55);  b := (b AND NativeUint(K55))+C;
  c :=((b shr 2)  AND NativeUint(K33));b := (b AND NativeUint(K33))+C;
  c:=   b shr 4;
  result := (b AND NativeUint(KF1))+c;
end;

Begin
End.
