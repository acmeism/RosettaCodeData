program ConcurrentComputing;
{$IFdef FPC}
  {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  {$IFDEF UNIX}
    cthreads,
  {$ENDIF}
  SysUtils, Classes;

type
  TRandomThread = class(TThread)
  private
    FString: string;
    T0 : Uint64;
  protected
    procedure Execute; override;
  public
    constructor Create(const aString: string); overload;
  end;
const
  MyStrings: array[0..2] of String = ('Enjoy ','Rosetta ','Code ');
var
  gblRunThdCnt : LongWord = 0;

constructor TRandomThread.Create(const aString: string);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FString := aString;
  interlockedincrement(gblRunThdCnt);
end;

procedure TRandomThread.Execute;
var
  i : NativeInt;
begin
  i := Random(300);
  T0 := GettickCount64;
  Sleep(i);
  //output of difference in time
  Writeln(FString,i:4,GettickCount64-T0 -i:2);
  interlockeddecrement(gblRunThdCnt);
end;

var
  lThreadArray: Array[0..9] of THandle;
  i : NativeInt;
begin
  Randomize;

  gblRunThdCnt := 0;
  For i := low(lThreadArray) to High(lThreadArray) do
    lThreadArray[i] := TRandomThread.Create(Format('%9s %4d',[myStrings[Random(3)],i])).Handle;

  while gblRunThdCnt > 0 do
    sleep(125);
end.
