program Function_prototype_class;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

type
  TStringListHelper1 = class helper for TStringList
    constructor Create(FileName: TFileName); overload;
  end;

  TStringListHelper2 = class helper (TStringListHelper1) for TStringList
    procedure SaveAndFree(FileName: TFileName);
  end;

    TStringListHelper3 = class helper (TStringListHelper2) for TStringList
    procedure AddDateTime;
  end;

{ TStringListHelper1 }

constructor TStringListHelper1.Create(FileName: TFileName);
begin
  inherited Create;
  if FileExists(FileName) then
    LoadFromFile(FileName);
end;

{ TStringListHelper2 }

procedure TStringListHelper2.SaveAndFree(FileName: TFileName);
begin
  SaveToFile(FileName);
  Free;
end;

{ TStringListHelper3 }

procedure TStringListHelper3.AddDateTime;
begin
  self.Add(DateToStr(now));
end;

begin
  with TStringList.Create('d:\Text.txt') do
  begin
    AddDateTime;
    SaveAndFree('d:\Text_done.txt');
  end;
  readln;
end.
