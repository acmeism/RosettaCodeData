public static bool IsNumeric(string s)
{
    double Result;
    return double.TryParse(s, out Result);  // TryParse routines were added in Framework version 2.0.
}

string value = "123";
if (IsNumeric(value))
{
  // do something
}
