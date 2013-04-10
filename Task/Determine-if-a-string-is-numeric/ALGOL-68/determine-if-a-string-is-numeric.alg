PROC is numeric = (REF STRING string) BOOL: (
  BOOL out := TRUE;
  PROC call back false = (REF FILE f)BOOL: (out:= FALSE; TRUE);

  FILE memory;
  associate(memory, string);
  on value error(memory, call back false);
  on logical file end(memory, call back false);

  UNION (INT, REAL, COMPL) numeric:=0.0;
  # use a FORMAT pattern instead of a regular expression #
  getf(memory, ($gl$, numeric));
  out
);

test:(
   STRING
     s1 := "152",
     s2 := "-3.1415926",
     s3 := "Foo123";
   print((
     s1, " results in ", is numeric(s1), new line,
     s2, " results in ", is numeric(s2), new line,
     s3, " results in ", is numeric(s3), new line
   ))
)
