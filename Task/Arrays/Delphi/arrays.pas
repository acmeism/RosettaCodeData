procedure TForm1.Button1Click(Sender: TObject);
var
  StaticArray: array[1..10] of Integer; // static arrays can start at any index
  DynamicArray: array of Integer; // dynamic arrays always start at 0
  StaticArrayText,
  DynamicArrayText: string;
  ixS, ixD: Integer;
begin
  // Setting the length of the dynamic array the same as the static one
  SetLength(DynamicArray, Length(StaticArray));
  // Asking random numbers storing into the static array
  for ixS := Low(StaticArray) to High(StaticArray) do
  begin
    StaticArray[ixS] := StrToInt(
      InputBox('Random number',
               'Enter a random number for position',
               IntToStr(ixS)));
  end;
  // Storing entered numbers of the static array in reverse order into the dynamic
  ixD := High(DynamicArray);
  for ixS := Low(StaticArray) to High(StaticArray) do
  begin
    DynamicArray[ixD] := StaticArray[ixS];
    Dec(ixD);
  end;
  // Concatenating the static and dynamic array into a single string variable
  StaticArrayText := '';
  for ixS := Low(StaticArray) to High(StaticArray) do
    StaticArrayText := StaticArrayText + IntToStr(StaticArray[ixS]);
  DynamicArrayText := '';
  for ixD := Low(DynamicArray) to High(DynamicArray) do
    DynamicArrayText := DynamicArrayText + IntToStr(DynamicArray[ixD]);
  end;
  // Displaying both arrays (#13#10 = Carriage Return/Line Feed)
  ShowMessage(StaticArrayText + #13#10 + DynamicArrayText);
end;
