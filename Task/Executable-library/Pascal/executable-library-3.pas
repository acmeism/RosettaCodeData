{$h+}
uses
  SysUtils, DynLibs;
const
  LIB_NAME = {$ifdef windows}'exec_lib.exe'{$else}'exec_lib'{$endif};
type
  THailSeq   = record
    Data: PCardinal;
    Count: Longint;
  end;
  THailstone = function(aValue: Cardinal): THailSeq;
  TCounts    = array[0..511] of Longint;
var
  LibName: string;
  hLib: TLibHandle;
  Fun: THailstone;
  I, Len, Count, c: Longint;
  Counts: TCounts;
begin
  LibName := ExtractFilePath(ParamStr(0))+LIB_NAME;
  hLib := LoadLibrary(LibName);
  if hLib = NilHandle then begin
    WriteLn('Can not load library ', LibName); Halt(1);
  end;
  Pointer(Fun) := GetProcAddress(hLib, 'Hailstone');
  if Pointer(Fun) = nil then begin
    WriteLn('Can not find Hailstone() function'); Halt(2);
  end;
  Counts := Default(TCounts);
  Count := 0;
  Len := 0;
  for I := 1 to 100000 do begin
    c := Fun(I).Count;
    Inc(Counts[c]);
    if Counts[c] > Count then begin
      Count := Counts[c];
      Len := c;
    end;
  end;
  UnloadLibrary(hLib);
  WriteLn('The most common Hailstone sequence length in the specified range is ',
           Len, ', it occurs ', Count, ' times.');
end.
