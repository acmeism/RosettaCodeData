#include <iostream>
#include <string_view>
#include <boost/hana.hpp>
#include <boost/hana/experimental/printable.hpp>

using namespace std;
namespace hana = boost::hana;

// Define the Amb function.  The first parameter is the constraint to be
// enforced followed by the potential values.
constexpr auto Amb(auto constraint, auto&& ...params)
{
  // create the set of all possible solutions
  auto possibleSolutions = hana::cartesian_product(hana::tuple(params...));

  // find one that matches the constraint
  auto foldOperation = [constraint](auto a, auto b)
  {
    bool meetsConstraint = constraint(a);
    return meetsConstraint ? a : b;
  };

  return hana::fold_right(possibleSolutions, foldOperation);
}

void AlgebraExample()
{
  // use a tuple to hold the possible values of each variable
  constexpr hana::tuple x{1, 2, 3};
  constexpr hana::tuple y{7, 6, 4, 5};

  // the constraint enforcing x * y == 8
  constexpr auto constraint = [](auto t)
  {
    return t[hana::size_c<0>] * t[hana::size_c<1>] == 8;
  };

  // find the solution using the Amb function
  auto result = Amb(constraint, x, y);

  cout << "\nx = " << hana::experimental::print(x);
  cout << "\ny = " << hana::experimental::print(y);
  cout << "\nx * y == 8: " << hana::experimental::print(result);
}

void StringExample()
{
  // the word lists to choose from
  constexpr hana::tuple words1 {"the"sv, "that"sv, "a"sv};
  constexpr hana::tuple words2 {"frog"sv, "elephant"sv, "thing"sv};
  constexpr hana::tuple words3 {"walked"sv, "treaded"sv, "grows"sv};
  constexpr hana::tuple words4 {"slowly"sv, "quickly"sv};

  // the constraint that the first letter of a word is the same as the last
  // letter of the previous word
  constexpr auto constraint = [](const auto t)
  {
    auto adjacent = hana::zip(hana::drop_back(t), hana::drop_front(t));
    return hana::all_of(adjacent, [](auto t)
    {
      return t[hana::size_c<0>].back() == t[hana::size_c<1>].front();
    });
  };


  // find the solution using the Amb function
  auto wordResult = Amb(constraint, words1, words2, words3, words4);

  cout << "\n\nWords 1: " << hana::experimental::print(words1);
  cout << "\nWords 2: " << hana::experimental::print(words2);
  cout << "\nWords 3: " << hana::experimental::print(words3);
  cout << "\nWords 4: " << hana::experimental::print(words4);
  cout << "\nSolution: " << hana::experimental::print(wordResult) << "\n";
}

int main()
{
  AlgebraExample();
  StringExample();
}
