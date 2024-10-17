var
  i: Integer;
  lList: TObjectList<TMyObject>;
begin
  lList := TObjectList<TMyObject>.Create;
  for i := 1 to 10 do
    lList.Add(TMyObject.Create);
  // ...
