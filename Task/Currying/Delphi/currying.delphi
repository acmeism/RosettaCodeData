program Currying;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  Plus: TFunc<Integer, TFunc<Integer, Integer>>;

begin
  Plus :=
    function(x: Integer): TFunc<Integer, Integer>
    begin
      result :=
        function(y: Integer): Integer
        begin
          result := x + y;
        end;
    end;

  Writeln(Plus(3)(4));
  Writeln(Plus(2)(Plus(3)(4)));
  readln;
end.
