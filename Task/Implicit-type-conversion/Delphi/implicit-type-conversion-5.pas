  ValueDouble := 1.6;
  ValueByte   := ValueDouble; // this not work, and raise a error
  ValueByte   : Trunc(ValueDouble); // this work, and assign 1
  ValueByte   : Round(ValueDouble); // this work, and assign 2
