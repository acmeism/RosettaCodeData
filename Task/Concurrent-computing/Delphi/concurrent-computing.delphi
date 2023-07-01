program ConcurrentComputing;

{$APPTYPE CONSOLE}

uses SysUtils, Classes, Windows;

type
  TRandomThread = class(TThread)
  private
    FString: string;
  protected
    procedure Execute; override;
  public
    constructor Create(const aString: string); overload;
  end;

constructor TRandomThread.Create(const aString: string);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FString := aString;
end;

procedure TRandomThread.Execute;
begin
  Sleep(Random(5) * 100);
  Writeln(FString);
end;

var
  lThreadArray: Array[0..2] of THandle;
begin
  Randomize;
  lThreadArray[0] := TRandomThread.Create('Enjoy').Handle;
  lThreadArray[1] := TRandomThread.Create('Rosetta').Handle;
  lThreadArray[2] := TRandomThread.Create('Stone').Handle;

  WaitForMultipleObjects(Length(lThreadArray), @lThreadArray, True, INFINITE);
end.
