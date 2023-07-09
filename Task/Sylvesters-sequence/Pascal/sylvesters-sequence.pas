program SylvesterSeq;

{$mode objfpc}{$H+}

uses SysUtils,
     UIntX; // in the library IntX4Pascal
(*
As noted in the Wikipedia article "Sylvester's sequence", we have
    1/2 + 1/3 + ... + 1/s[j-1] = (s[j] - 2)/(s[j] - 1),
so that instead of summing the reciprocals explicitly we can just
calculate an extra term.
*)
var
  s : UIntX.TIntX; // arbitrarily large integer
  i : integer;
begin
  s := 1;
  for i := 0 to 9 do begin
    inc(s);
    WriteLn( SysUtils.Format( 's[%d] = %s', [i, s.ToString]));
    s := s*(s - 1);
  end;
  WriteLn( 'Sum of reciprocals =');
  WriteLn( (s - 1).ToString);
  WriteLn( '/'); // on a separate line for clarity
  WriteLn( s.ToString);
end.
