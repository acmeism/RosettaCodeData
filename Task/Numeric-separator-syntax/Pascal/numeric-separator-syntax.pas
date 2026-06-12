program test;
{$mode fpc}
{$modeswitch underscoreisseparator}
begin
  WriteLn(%1001_1001);
  WriteLn(&121_102);
  WriteLn(-1_123_123);
  WriteLn($1_123_123);
  WriteLn(-1_123___123.000_000);
  WriteLn(1_123_123.000_000e1_2);
end.
