program PolymorphicCopy;

type
  T = class
    function Name:String; virtual;
    function Clone:T; virtual;
  end;

  S = class(T)
    function Name:String; override;
    function Clone:T; override;
  end;

function T.Name :String; begin Exit('T')     end;
function T.Clone:T;      begin Exit(T.Create)end;

function S.Name :String; begin Exit('S')     end;
function S.Clone:T;      begin Exit(S.Create)end;

procedure Main;
var
  Original, Clone :T;
begin
  Original := S.Create;
  Clone    := Original.Clone;

  WriteLn(Original.Name);
  WriteLn(Clone.Name);
end;

begin
  Main;
end.
