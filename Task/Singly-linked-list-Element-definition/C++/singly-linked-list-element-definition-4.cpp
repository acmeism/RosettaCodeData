template<typename T> struct link
{
  link* next;
  T data;
  link(T a_data, link* a_next = 0): next(a_next), data(a_data) {}
};
