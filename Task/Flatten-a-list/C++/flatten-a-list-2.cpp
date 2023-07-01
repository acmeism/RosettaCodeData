#include <cctype>
#include <iostream>

// *******************
// * the list parser *
// *******************

void skipwhite(char const** s)
{
  while (**s && std::isspace((unsigned char)**s))
  {
    ++*s;
  }
}

anylist create_anylist_i(char const** s)
{
  anylist result;
  skipwhite(s);
  if (**s != '[')
    throw "Not a list";
  ++*s;
  while (true)
  {
    skipwhite(s);
    if (!**s)
      throw "Error";
    else if (**s == ']')
    {
      ++*s;
      return result;
    }
    else if (**s == '[')
      result.push_back(create_anylist_i(s));
    else if (std::isdigit((unsigned char)**s))
    {
      int i = 0;
      while (std::isdigit((unsigned char)**s))
      {
        i = 10*i + (**s - '0');
        ++*s;
      }
      result.push_back(i);
    }
    else
      throw "Error";

    skipwhite(s);
    if (**s != ',' && **s != ']')
      throw "Error";
    if (**s == ',')
      ++*s;
  }
}

anylist create_anylist(char const* i)
{
  return create_anylist_i(&i);
}

// *************************
// * printing nested lists *
// *************************

void print_list(anylist const& list);

void print_item(boost::any const& a)
{
  if (a.type() == typeid(int))
    std::cout << boost::any_cast<int>(a);
  else if (a.type() == typeid(anylist))
    print_list(boost::any_cast<anylist const&>(a));
  else
    std::cout << "???";
}

void print_list(anylist const& list)
{
  std::cout << '[';
  anylist::const_iterator iter = list.begin();
  while (iter != list.end())
  {
    print_item(*iter);
    ++iter;
    if (iter != list.end())
      std::cout << ", ";
  }
  std::cout << ']';
}

// ***************************
// * The actual test program *
// ***************************

int main()
{
  anylist list =
    create_anylist("[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]");
  print_list(list);
  std::cout << "\n";
  flatten(list);
  print_list(list);
  std::cout << "\n";
}
