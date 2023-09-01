program IsNumeric;

type
    TDynamicArrayItem = record
    StrValue: string;
  end;

var
  myDynamicArray: array of TDynamicArrayItem;
  i: Integer;
  Value: Extended;
  Code: Integer;

begin
  // Initialize the dynamic array with different data types
  SetLength(myDynamicArray, 7);
  myDynamicArray[0].StrValue := 'Hello';
  myDynamicArray[1].StrValue := '42';
  myDynamicArray[2].StrValue := '3.14159';
  myDynamicArray[3].StrValue := 'World';
  myDynamicArray[4].StrValue := '99';
  myDynamicArray[5].StrValue := '0777'; // Octal representation for 511
  myDynamicArray[6].StrValue := '$A1';  // Hexadecimal representation for 161

  // Iterate through the dynamic array and determine data type
  for i := Low(myDynamicArray) to High(myDynamicArray) do
  begin
    Val(myDynamicArray[i].StrValue, Value, Code);
    if Code = 0 then // The value 0 for Code indicates that the conversion was successful.
        Writeln('Element ', i, ': Numeric Value ', Chr(9),' - ', Value) // Chr(9) = tab
    else
        Writeln('Element ', i, ': Non-Numeric Value ', Chr(9), ' - ', myDynamicArray[i].StrValue);
  end;
end.
{ Val converts the value represented in the string 'StrValue' to a numerical value or an enumerated value, and stores this value in the variable 'Value', which can be of type Longint, Real and Byte or any enumerated type. If the conversion isn't successful, then the parameter 'Code' contains the index of the character in 'StrValue' which prevented the conversion. }
