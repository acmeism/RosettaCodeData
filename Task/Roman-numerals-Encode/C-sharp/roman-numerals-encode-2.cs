Func<int, string> toRoman = (number) =>
  new Dictionary<int, string>
  {
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  }.Aggregate(new string('I', number), (m, _) => m.Replace(new string('I', _.Key), _.Value));
