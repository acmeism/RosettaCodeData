type
  TReturnArray = array of integer; //you need to define a type to be able to return it

function ConcatArray(a1,a2:array of integer):TReturnArray;
var
  i,r:integer;
begin
  { Low(array) is not necessarily 0 }
  SetLength(result,High(a1)-Low(a1)+High(a2)-Low(a2)+2); //BAD idea to set a length you won't release, just to show the idea!
  r:=0; //index on the result may be different to indexes on the sources
  for i := Low(a1) to High(a1) do begin
    result[r] := a1[i];
    Inc(r);
  end;
  for i := Low(a2) to High(a2) do begin
    result[r] := a2[i];
    Inc(r);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  a1,a2:array of integer;
  r1:array of integer;
  i:integer;
begin
  SetLength(a1,4);
  SetLength(a2,3);
  for i := Low(a1) to High(a1) do
    a1[i] := i;
  for i := Low(a2) to High(a2) do
    a2[i] := i;
  TReturnArray(r1) := ConcatArray(a1,a2);
  for i := Low(r1) to High(r1) do
    showMessage(IntToStr(r1[i]));
  Finalize(r1); //IMPORTANT!
  ShowMessage(IntToStr(High(r1)));
end;
