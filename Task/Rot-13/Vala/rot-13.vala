string rot13(string s) {
  const string lcalph = "abcdefghijklmnopqrstuvwxyz";
  const string ucalph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  string result = "";
  int pos;
  unichar c;

  for (int i = 0; s.get_next_char (ref i, out c);) {
    if ((pos = lcalph.index_of_char(c)) != -1)
      result += lcalph[(pos + 13) % 26].to_string();
    else if ((pos = ucalph.index_of_char(c)) != -1)
      result += ucalph[(pos + 13) % 26].to_string();
    else
      result += c.to_string();
  }

  return result;
}

void main() {
  print(rot13("The Quick Brown Fox Jumped Over the Lazy Dog!"));
}
