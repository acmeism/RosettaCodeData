#include <iostream>
#include <set>
#include <vector>
#include <iterator>
#include <algorithm>
typedef std::set<int> set_type;
typedef std::set<set_type> powerset_type;

powerset_type powerset(set_type const& set)
{
  typedef set_type::const_iterator set_iter;
  typedef std::vector<set_iter> vec;
  typedef vec::iterator vec_iter;

  struct local
  {
    static int dereference(set_iter v) { return *v; }
  };

  powerset_type result;

  vec elements;
  do
  {
    set_type tmp;
    std::transform(elements.begin(), elements.end(),
                   std::inserter(tmp, tmp.end()),
                   local::dereference);
    result.insert(tmp);
    if (!elements.empty() && ++elements.back() == set.end())
    {
      elements.pop_back();
    }
    else
    {
      set_iter iter;
      if (elements.empty())
      {
        iter = set.begin();
      }
      else
      {
        iter = elements.back();
        ++iter;
      }
      for (; iter != set.end(); ++iter)
      {
        elements.push_back(iter);
      }
    }
  } while (!elements.empty());

  return result;
}

int main()
{
  int values[4] = { 2, 3, 5, 7 };
  set_type test_set(values, values+4);

  powerset_type test_powerset = powerset(test_set);

  for (powerset_type::iterator iter = test_powerset.begin();
       iter != test_powerset.end();
       ++iter)
  {
    std::cout << "{ ";
    char const* prefix = "";
    for (set_type::iterator iter2 = iter->begin();
         iter2 != iter->end();
         ++iter2)
    {
      std::cout << prefix << *iter2;
      prefix = ", ";
    }
    std::cout << " }\n";
  }
}
