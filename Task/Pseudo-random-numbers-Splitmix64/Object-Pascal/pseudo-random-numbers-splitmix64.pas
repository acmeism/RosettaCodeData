program splitmix64;

{$IF Defined(FPC)}{$MODE Delphi}{$ENDIF}
{$INLINE ON}
{$Q-}{$R-}

{
  Written in 2015 by Sebastiano Vigna (vigna@acm.org)
  http://prng.di.unimi.it/splitmix64.c

  Onject Pascal port written in 2020 by I. Kakoulidis

  To the extent possible under law, the author has dedicated all copyright
  and related and neighboring rights to this software to the public domain
  worldwide. This software is distributed without any warranty.

  See <http://creativecommons.org/publicdomain/zero/1.0/>.
}

{
  This is a fixed-increment version of Java 8's SplittableRandom generator
  See http://dx.doi.org/10.1145/2714064.2660195 and
  http://docs.oracle.com/javase/8/docs/api/java/util/SplittableRandom.html

  It is a very fast generator passing BigCrush, and it can be useful if
  for some reason you absolutely want 64 bits of state.
}
uses Math;

type
  TSplitMix64 = record
    state: UInt64;
    procedure Init(seed: UInt64); inline;
    function Next(): UInt64; inline;
    function NextFloat(): double; inline;
  end;

procedure TSplitMix64.Init(seed: UInt64);
begin
  state := seed;
end;

function TSplitMix64.Next(): UInt64;
begin
  state := state + UInt64($9e3779b97f4a7c15);
  Result := state;
  Result := (Result xor (Result shr 30)) * UInt64($bf58476d1ce4e5b9);
  Result := (Result xor (Result shr 27)) * UInt64($94d049bb133111eb);
  Result := Result xor (Result shr 31);
end;

function TSplitMix64.NextFloat(): Double;
begin
  Result := Next() / 18446744073709551616.0;
end;

var
  r: TSplitMix64;
  i, j: Integer;
  vec: array[0..4] of Integer;

begin
  j := 0;
  r.Init(1234567);
  for i := 0 to 4 do
    WriteLn(r.Next());

  r.Init(987654321);
  for i := 0 to 99999 do
  begin
    j := Trunc(r.NextFloat() * 5.0);
    Inc(vec[j]);
  end;

  for i := 0 to 4 do
    Write(i, ': ', vec[i], '  ');
end.
