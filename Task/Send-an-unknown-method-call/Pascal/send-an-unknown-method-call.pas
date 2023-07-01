program Test;
{$mode objfpc}{$h+}
uses
  SysUtils;

type
  TProc = procedure of object;

{$push}{$m+}
  TMyObj = class
  strict private
    FName: string;
  public
    constructor Create(const aName: string);
    property Name: string read FName;
  published
    procedure Foo;
    procedure Bar;
  end;
{$pop}

constructor TMyObj.Create(const aName: string);
begin
  FName := aName;
end;

procedure TMyObj.Foo;
begin
  WriteLn(Format('This is %s.Foo()', [Name]));
end;

procedure TMyObj.Bar;
begin
  WriteLn(Format('This is %s.Bar()', [Name]));
end;

procedure CallByName(o: TMyObj; const aName: string);
var
  m: TMethod;
begin
  m.Code := o.MethodAddress(aName);
  if m.Code <> nil then begin
    m.Data := o;
    TProc(m)();
  end else
    WriteLn(Format('Unknown method(%s)', [aName]));
end;

var
  o: TMyObj;

begin
  o := TMyObj.Create('Obj');
  CallByName(o, 'Bar');
  CallByName(o, 'Foo');
  CallByName(o, 'Baz');
  o.Free;
end.
