unit MyObjDef;
{$mode objfpc}{$h+}
interface

uses
  SysUtils, Variants;

  function MyObjCreate: Variant;

implementation

var
  MyObjType: TInvokeableVariantType;

type
  TMyObjType = class(TInvokeableVariantType)
    procedure Clear(var V: TVarData); override;
    procedure Copy(var aDst: TVarData; const aSrc: TVarData; const Indir: Boolean); override;
    function GetProperty(var aDst: TVarData; const aData: TVarData; const aName: string): Boolean; override;
  end;

function MyObjCreate: Variant;
begin
  Result := Unassigned;
  TVarData(Result).VType := MyObjType.VarType;
end;

procedure TMyObjType.Clear(var V: TVarData);
begin
  V.VType := varEmpty;
end;

procedure TMyObjType.Copy(var aDst: TVarData; const aSrc: TVarData; const Indir: Boolean);
begin
  VarClear(Variant(aDst));
  aDst := aSrc;
end;

function TMyObjType.GetProperty(var aDst: TVarData; const aData: TVarData; const aName: string): Boolean;
begin
  Result := True;
  case LowerCase(aName) of
    'bark':   Variant(aDst) := 'WOF WOF!';
    'moo':    Variant(aDst) := 'Mooo!';
  else
    Variant(aDst) := Format('Sorry, what is "%s"?', [aName]);
  end;
end;

initialization
  MyObjType := TMyObjType.Create;
finalization
  MyObjType.Free;
end.
