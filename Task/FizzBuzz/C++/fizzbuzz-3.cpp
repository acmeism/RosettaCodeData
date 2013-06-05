#include <iostream>
#include <algorithm>
#include <vector>

int main()
{
  std::vector<int> range(100);
  std::iota(range.begin(), range.end(), 1);

  std::vector<std::string> values;
  values.resize(range.size());

  auto fizzbuzz = [](int i) -> std::string {
    if ((i%15) == 0) return "FizzBuzz";
    if ((i%5) == 0)  return "Buzz";
    if ((i%3) == 0)  return "Fizz";
    return std::to_string(i);
  };

  std::transform(range.begin(), range.end(), values.begin(), fizzbuzz);

  for (auto& str: values) std::cout << str << std::endl;

  return 0;
}
