  ValueDWord := 4294967295; // 4294967295 (Max DWord value (unsigned))
  ValueInteger : Integer   := ValueDWord; // -1 (two complement conversion) (signed)
  ValueDWord := ValueInteger; // 4294967295 (convert back, unsigned)
