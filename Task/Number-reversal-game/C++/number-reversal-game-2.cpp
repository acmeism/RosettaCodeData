#include <iostream>
#include <algorithm>
#include <functional>
#include <iterator>
#include <cstdlib>
#include <ctime>

template<typename T, int size>
 bool is_sorted(T (&array)[size])
{
  return std::adjacent_find(array, array+size, std::greater<T>())
    == array+size;
}

int main()
{
  std::srand(std::time(0));

  int list[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9 };

  do
  {
    std::random_shuffle(list, list+9);
  } while (is_sorted(list));

  int score = 0;

  do
  {
    std::cout << "Current list: ";
    std::copy(list, list+9, std::ostream_iterator<int>(std::cout, " "));

    int rev;
    while (true)
    {
      std::cout << "\nDigits to reverse? ";
      std::cin >> rev;
      if (rev > 1 && rev < 10)
        break;
      std::cout << "Please enter a value between 2 and 9.";
    }

    ++score;
    std::reverse(list, list + rev);
  } while (!is_sorted(list));

  std::cout << "Congratulations, you sorted the list.\n"
            << "You needed " << score << " reversals." << std::endl;
  return 0;
}
