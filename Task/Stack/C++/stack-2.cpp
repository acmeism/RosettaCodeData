#include <deque>
template <class T, class Sequence = std::deque<T> >
class stack {
  friend bool operator== (const stack&, const stack&);
  friend bool operator<  (const stack&, const stack&);
public:
  typedef typename Sequence::value_type      value_type;
  typedef typename Sequence::size_type       size_type;
  typedef          Sequence                  container_type;
  typedef typename Sequence::reference       reference;
  typedef typename Sequence::const_reference const_reference;
protected:
  Sequence seq;
public:
  stack() : seq() {}
  explicit stack(const Sequence& s0) : seq(s0) {}
  bool empty() const { return seq.empty(); }
  size_type size() const { return seq.size(); }
  reference top() { return seq.back(); }
  const_reference top() const { return seq.back(); }
  void push(const value_type& x) { seq.push_back(x); }
  void pop() { seq.pop_back(); }
};

template <class T, class Sequence>
bool operator==(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return x.seq == y.seq;
}
template <class T, class Sequence>
bool operator<(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return x.seq < y.seq;
}

template <class T, class Sequence>
bool operator!=(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return !(x == y);
}
template <class T, class Sequence>
bool operator>(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return y < x;
}
template <class T, class Sequence>
bool operator<=(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return !(y < x);
}
template <class T, class Sequence>
bool operator>=(const stack<T,Sequence>& x, const stack<T,Sequence>& y)
{
  return !(x < y);
}
