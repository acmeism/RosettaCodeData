public static bool IsNumeric(string s)
{
  try
  {
    Double.Parse(s);
    return true;
  }
  catch
  {
    return false;
  }
}
