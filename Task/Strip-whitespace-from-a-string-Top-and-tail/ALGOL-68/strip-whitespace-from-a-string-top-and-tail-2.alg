#
  string_trim
  Trim leading and trailing whitespace from string.

  @param str A string.
  @return A string trimmed of leading and trailing white space.
#
PROC string_trim = (STRING str) STRING: (
    INT i := 1, j := 0;
    WHILE str[i] = blank DO
        i +:= 1
    OD;
    WHILE str[UPB str - j] = blank DO
        j +:= 1
    OD;
    str[i:UPB str - j]
);

# test # (
    IF string_trim("   foobar") /= "foobar" THEN
        print(("string_trim('   foobar'): expected 'foobar'; actual: "
              + string_trim("   foobar"), newline)) FI;
    IF string_trim("foobar   ") /= "foobar" THEN
        print(("string_trim('foobar   '): expected 'foobar'; actual: "
              + string_trim("foobar   "), newline)) FI;
    IF string_trim("   foobar   ") /= "foobar" THEN
        print(("string_trim('   foobar   '): expected 'foobar'; actual: "
              + string_trim("   foobar   "), newline)) FI
)
