String split(String input, String delim) {
  String res = '';
  for (int i = 0; i < input.length; i++) {
    if (res.isNotEmpty && input[i] != res[res.length - 1]) {
      res += delim;
    }
    res += input[i];
  }
  return res;
}

void main() {
  print(split("gHHH5  ))YY++,,,///\\", ", "));
}
