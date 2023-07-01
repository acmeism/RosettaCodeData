template<typename T> void swap(T& left, T& right)
{
  T tmp(left);
  left = right;
  right = tmp;
}
