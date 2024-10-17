var
  i: Integer;
  lObject: TMyObject;
  lList: TObjectList<TMyObject>;
begin
  lList := TObjectList<TMyObject>.Create;
  lObject := TMyObject.Create;
  for i := 1 to 10 do
    lList.Add(lObject);
  // ...
