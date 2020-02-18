string to_roman(int n)
  requires (n > 0 && n < 5000)
{
  const int[] weights = {1000, 900, 500, 400, 100, 90,
                         50, 40, 10, 9, 5, 4, 1};
  const string[] symbols = {"M","CM","D","CD","C","XC","L",
                            "XL","X","IX","V","IV","I"};

  var roman = "", count = 0;
  foreach (var w in weights) {
    while (n >= w) {
      roman += symbols[count];
      n -= w;
    }
    if (n == 0)
      break;
    count++;
  }
  return roman;
}

void main() {
  print("%s\n", to_roman(455));
  print("%s\n", to_roman(3456));
  print("%s\n", to_roman(2488));
}
