program DebugApp;

{$APPTYPE CONSOLE}

uses
  winapi.windows,
  System.sysutils,
  System.ioutils;

var
  OldAssert: TAssertErrorProc;

procedure HookAssert(const M, F: string; L: Integer; E: Pointer);
var
  msg: string;
  fFile: Text;
const
  LOG_FILE = '.\Debug.log';
begin
  msg := '[' + DateTimeToStr(now) + ']';
  msg := msg + format(' [Line: %.4d] File: %s', [L, F]);

  Assign(fFile, LOG_FILE);
  if FileExists(LOG_FILE) then
    Append(fFile)
  else
    Rewrite(fFile);
  Write(fFile, msg + #10);
  Write(fFile, M + #10);
  Close(fFile);
// Uncomment next line to enable the original assert function
// OldAssert(M, F, L, E);
end;

procedure AttachDebug;
begin
  OldAssert := AssertErrorProc;
  AssertErrorProc := HookAssert;
end;

procedure ReleaseDebug;
begin
  AssertErrorProc := OldAssert;
end;

function Add(x, y: Integer): Integer;
begin
  Result := x + y;
  Assert(false, (format('%d + %d = %d', [x, y, result])));
end;

begin
  AttachDebug;

  writeln(Add(2, 7));

  ReleaseDebug;
end.
