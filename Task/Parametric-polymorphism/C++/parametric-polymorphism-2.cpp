template<class T>
void tree<T>::replace_all (T new_value)
{
  value = new_value;
  left->replace_all (new_value);
  right->replace_all (new_value);
}
