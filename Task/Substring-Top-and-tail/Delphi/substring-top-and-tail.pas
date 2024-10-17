program TopAndTail;

{$APPTYPE CONSOLE}

const
  TEST_STRING = '1234567890';
begin
  Writeln(TEST_STRING);                                    // full string
  Writeln(Copy(TEST_STRING, 2, Length(TEST_STRING)));      // first character removed
  Writeln(Copy(TEST_STRING, 1, Length(TEST_STRING) - 1));  // last character removed
  Writeln(Copy(TEST_STRING, 2, Length(TEST_STRING) - 2));  // first and last characters removed

  Readln;
end.
