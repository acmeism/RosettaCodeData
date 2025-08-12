program justasabstract;
{$ifdef fpc}{$mode objfpc}{$endif}
type
  IAnimalInterface = interface
  ['{BD40E312-36AD-4F8B-A3EF-727F2474E494}']
    function noise:string;
    function move:string;
 end;

  Tbird = class(TInterfacedObject,IAnimalInterface)
  strict private
    function noise:string;virtual;
    function move:string;virtual;
  end;

  function TBird.Noise:string;
  begin
    Result := 'Tjirpp';
  end;

 function TBird.move:string;
  begin
    Result := 'I fly';
  end;

var
  bird:IAnimalInterface; // as interface, this unhides the strict private methods too.
begin
  bird := TBird.Create;
  writeln(bird.noise);
  writeln(bird.move);
end.
