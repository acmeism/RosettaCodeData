Program CPU_Utilization;

{$mode ObjFPC}
{$H+}

uses
  sysutils, strutils;

const
  C_INFNAME = '/proc/stat';

var
  filestr: ansistring;
  tfIn: TextFile;
  a: TStringArray;
  i, total, idle: uint32;
  PrevTotal: uint32 = 0;
  PrevIdle: uint32 = 0;

begin
  AssignFile(tfIn, C_INFNAME);
  try
    while True do
    begin
      Reset(tfIn);
      ReadLn(tfIn, filestr); // ReadLn reads a line from the file
      a := filestr.Split([' ']);
      total := 0;
      for i := 2 to High(a) do
        Inc(total, StrToInt(a[i]));
      idle := StrToInt(a[5]); // there is an empty field
      Writeln((1.0 - (idle - PrevIdle) / (total - PrevTotal)) * 100:4:1, '%');
      PrevIdle := idle;
      PrevTotal := total;
      Sleep(500);
    end;
  finally
    CloseFile(tfIn); // Close the file when done
  end;
end.

