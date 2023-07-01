unit MyObjDef;
{$mode objfpc}{$h+}{$interfaces com}
interface

function MyObjCreate: Variant;

implementation
uses
  Variants, Generics.Collections;

var
  MyObjType: TInvokeableVariantType;

type
  IMyObj = interface
    procedure SetVar(const aName: string; const aValue: Variant);
    function  GetVar(const aName: string): Variant;
  end;

  TMyObj = class(TInterfacedObject, IMyObj)
  strict private
    FMap: specialize TDictionary<string, Variant>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetVar(const aName: string; const aValue: Variant);
    function  GetVar(const aName: string): Variant;
  end;

  TMyData = packed record
    VType:  TVarType;
    Dummy1: array[0..5] of Byte;
    Dummy2: Pointer;
    FObj: IMyObj;
  end;

  TMyObjType = class(TInvokeableVariantType)
    procedure Clear(var V: TVarData); override;
    procedure Copy(var aDst: TVarData; const aSrc: TVarData; const Indir: Boolean); override;
    function  GetProperty(var aDst: TVarData; const aData: TVarData; const aName: string): Boolean; override;
    function  SetProperty(var V: TVarData; const aName: string; const aData: TVarData): Boolean; override;
  end;

function MyObjCreate: Variant;
begin
  VarClear(Result);
  TMyData(Result).VType := MyObjType.VarType;
  TMyData(Result).FObj := TMyObj.Create;
end;

constructor TMyObj.Create;
begin
  FMap := specialize TDictionary<string, Variant>.Create;
end;

destructor TMyObj.Destroy;
begin
  FMap.Free;
  inherited;
end;

procedure TMyObj.SetVar(const aName: string; const aValue: Variant);
begin
  FMap.AddOrSetValue(LowerCase(aName), aValue);
end;

function TMyObj.GetVar(const aName: string): Variant;
begin
  if not FMap.TryGetValue(LowerCase(aName), Result) then Result := Null;
end;

procedure TMyObjType.Clear(var V: TVarData);
begin
  TMyData(V).FObj := nil;
  V.VType := varEmpty;
end;

procedure TMyObjType.Copy(var aDst: TVarData; const aSrc: TVarData; const Indir: Boolean);
begin
  VarClear(Variant(aDst));
  TMyData(aDst) := TMyData(aSrc);
end;

function TMyObjType.GetProperty(var aDst: TVarData; const aData: TVarData; const aName: string): Boolean;
begin
  Result := True;
  Variant(aDst) := TMyData(aData).FObj.GetVar(aName);
end;

function TMyObjType.SetProperty(var V: TVarData; const aName: string; const aData: TVarData): Boolean;
begin
  Result := True;
  TMyData(V).FObj.SetVar(aName, Variant(aData));
end;

initialization
  MyObjType := TMyObjType.Create;
finalization
  MyObjType.Free;
end.
