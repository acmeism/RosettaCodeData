#include <iostream>
#include <list>
#include <string>
#include <vector>

using namespace std;

// Use iterators to print all of the elements of any container that supports
// iterators.  It print elements starting at 'start' up to, but not
// including, 'sentinel'.
void PrintContainer(forward_iterator auto start, forward_iterator auto sentinel)
{
  for(auto it = start; it != sentinel; ++it)
  {
    cout << *it << " ";
  }
  cout << "\n";
}

// Use an iterator to print the first, fourth, and fifth elements
void FirstFourthFifth(input_iterator auto it)
{
  cout << *it;
  advance(it, 3);
  cout << ", " << *it;
  advance(it, 1);
  cout << ", " << *it;
  cout << "\n";
}

int main()
{
  // Create two differnt kinds of containers of strings
  vector<string> days{"Sunday", "Monday", "Tuesday", "Wednesday",
   "Thursday", "Friday", "Saturday"};
  list<string> colors{"Red", "Orange", "Yellow", "Green", "Blue", "Purple"};

  cout << "All elements:\n";
  PrintContainer(days.begin(), days.end());
  PrintContainer(colors.begin(), colors.end());

  cout << "\nFirst, fourth, and fifth elements:\n";
  FirstFourthFifth(days.begin());
  FirstFourthFifth(colors.begin());

  cout << "\nReverse first, fourth, and fifth elements:\n";
  FirstFourthFifth(days.rbegin());
  FirstFourthFifth(colors.rbegin());
}
