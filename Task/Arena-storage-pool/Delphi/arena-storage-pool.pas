program Arena_storage_pool;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  system.generics.collections;

type
  TPool = class
  private
    FStorage: TList<Pointer>;
  public
    constructor Create;
    destructor Destroy; override;
    function Allocate(aSize: Integer): Pointer;
    function Release(P: Pointer): Integer;
  end;

{ TPool }

function TPool.Allocate(aSize: Integer): Pointer;
begin
  Result := GetMemory(aSize);
  if Assigned(Result) then
    FStorage.Add(Result);
end;

constructor TPool.Create;
begin
  FStorage := TList<Pointer>.Create;
end;

destructor TPool.Destroy;
var
  p: Pointer;
begin
  while FStorage.Count > 0 do
  begin
    p := FStorage[0];
    Release(p);
  end;
  FStorage.Free;
  inherited;
end;

function TPool.Release(P: Pointer): Integer;
var
  index: Integer;
begin
  index := FStorage.IndexOf(P);
  if index > -1 then
    FStorage.Delete(index);
  FreeMemory(P)
end;

var
  Manager: TPool;
  int1, int2: PInteger;
  str: PChar;

begin
  Manager := TPool.Create;
  int1 := Manager.Allocate(sizeof(Integer));
  int1^ := 5;

  int2 := Manager.Allocate(sizeof(Integer));
  int2^ := 3;

  writeln('Allocate at addres ', cardinal(int1).ToHexString, ' with value of ', int1^);
  writeln('Allocate at addres ', cardinal(int2).ToHexString, ' with value of ', int2^);

  Manager.Free;
  readln;
end.
