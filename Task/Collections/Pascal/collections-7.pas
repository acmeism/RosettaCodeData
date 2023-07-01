Program ex34;

{ Program to demonstrate the TCollection.AtInsert method }

Uses Objects, MyObject; { For TMyObject definition and registration }

Var C : PCollection;
    M : PMyObject;
    I : Longint;

Procedure PrintField (Dummy : Pointer; P : PMyObject);

begin
  Writeln ('Field : ',P^.GetField);
end;

begin
  Randomize;
  C:=New(PCollection, Init(120, 10));
  Writeln ('Inserting 100 records at random places.');
  For I:=1 to 100 do
    begin
    M:=New(PMyObject, Init);
    M^.SetField(I-1);
    If I=1 then
      C^.Insert(M)
    else
      With C^ do
        AtInsert(Random(Count), M);
    end;
  Writeln ('Values : ');
  C^.Foreach(@PrintField);
  Dispose(C, Done);
end.
