program abstracts;
// this code also compiles in delphi
{$ifdef fpc}{$mode objfpc}{$endif}
type
  // Pure Abstract Class. In cs theory also known as an interface,
  // because it has no implementation
  TAbstractClass = class abstract
  protected
    function noise:string;virtual;abstract;
  end;
  // classic inheritance
  Tdog = class(TAbstractClass)
  public
    function noise:string;override;
  end;

  Tcat = class(TAbstractClass)
  public
    function noise:string;override;
  end;

  // unrelated class that matches the interface of TAbstractClass, the VMT.
  Tbird = class
  strict private
    FField:string;
    function noise:string;virtual;
    property field:string read FField write FField;
  end;

  function Tdog.Noise:string;
  begin
    Result := 'Woof';
  end;

  function Tcat.Noise:string;
  begin
    Result := 'Miauw';
  end;

  function TBird.Noise:string;
  begin
    Result := 'Tjirpp';
  end;

var
  cat, dog: TAbstractClass;
  bird:Tbird;
begin
  cat := Tcat.Create;
  dog := Tdog.Create;
  bird := TBird.Create;
  writeln(cat.noise,dog.noise);
  // even this works, because the layout is the same
  // This is similar to C++, where pure abstract classes are interfaces.
  writeln(TAbstractClass(bird).noise);
  bird.free;
  dog.free;
  cat.free;
  readln;
end.
