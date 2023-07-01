#include <list>
#include <boost/any.hpp>

typedef std::list<boost::any> anylist;

void flatten(std::list<boost::any>& list)
{
  typedef anylist::iterator iterator;

  iterator current = list.begin();
  while (current != list.end())
  {
    if (current->type() == typeid(anylist))
    {
      iterator next = current;
      ++next;
      list.splice(next, boost::any_cast<anylist&>(*current));
      current = list.erase(current);
    }
    else
      ++current;
  }
}
