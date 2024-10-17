program DeepCopyApp;

{$APPTYPE CONSOLE}

uses
  System.TypInfo;

type
  TTypeA = record
    value1: integer;
    value2: char;
    value3: string[10];
    value4: Boolean;
    function DeepCopy: TTypeA;
  end;

{ TTypeA }

function TTypeA.DeepCopy: TTypeA;
begin
  CopyRecord(@result, @self, TypeInfo(TTypeA));
end;

var
  a, b: TTypeA;

begin
  a.value1 := 10;
  a.value2 := 'A';
  a.value3 := 'OK';
  a.value4 := True;

  b := a.DeepCopy;
  a.value1 := 20;
  a.value2 := 'B';
  a.value3 := 'NOK';
  a.value4 := False;

  Writeln('Value of "a":');
  Writeln(a.value1);
  Writeln(a.value2);
  Writeln(a.value3);
  Writeln(a.value4);

  Writeln(#10'Value of "b":');
  Writeln(b.value1);
  Writeln(b.value2);
  Writeln(b.value3);
  Writeln(b.value4);
  readln;
end.
