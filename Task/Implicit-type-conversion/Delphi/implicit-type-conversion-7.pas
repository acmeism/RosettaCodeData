  ValueBoolean: Boolean := True; // this work, and assign True
  ValueBoolean: Boolean := 1;    // this not work, and raise a error
  ValueByte   := ValueBoolean;   // this not work, and raise a error
  ValueByte   := Byte(ValueBoolean);   // this work, and assign 1
  ValueBoolean   := Boolean(10);   // this work, and assign true
  ValueBoolean   := Boolean(-1);   // this work, and assign true
  ValueBoolean   := Boolean( 0);   // this work, and assign false
