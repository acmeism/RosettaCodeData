program FilterEven;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Types,
  Boost.Int;

var
  Source, Destiny: TIntegerDynArray;

begin
  Source.Assign([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);

  // Non-destructively
  Destiny := Source.Filter(
    function(Item: Integer): Boolean
    begin
      Result := not odd(Item) and (Item <> 0);
    end);

  Writeln('[' + Destiny.Comma + ']');
  Readln;
end.

  // Destructively
  Source.Remove(
    function(Item: Integer): Boolean
    begin
      Result := odd(Item) or (Item = 0);
    end);

  Writeln('[' + Source.Comma + ']');
End.
