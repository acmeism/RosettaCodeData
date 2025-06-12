program byconstruct;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Math, Generics.Collections;

var
  start: TList<Char>;
  piece: Char;
  bishpos: Integer;
  resultString: String;

begin
  Randomize;

  start := TList<Char>.Create;

  try
    start.AddRange(['R', 'K', 'R']); // <<

    for piece in ['Q', 'N', 'N'] do
      start.Insert(Random(start.Count), piece); // <<

    bishpos := Random(start.Count);
    start.Insert(bishpos, 'B'); // <<

    if bishpos mod 2 = 0 then
      start.Insert(Random(start.Count div 2) * 2, 'B') // <<
    else
      start.Insert(Random((start.Count - bishpos + 1) div 2) * 2 + bishpos, 'B'); // <<

    // Convert TList<Char> to String
    resultString := String.Create(start.ToArray);

    WriteLn(resultString);

  finally
    start.Free;
  end;
end.
