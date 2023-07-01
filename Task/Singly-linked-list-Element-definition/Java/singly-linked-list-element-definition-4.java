class Link<T>
{
  Link<T> next;
  T data;
  Link(T a_data, Link<T> a_next) { next = a_next; data = a_data; }
}
