template<class T>
void tree<T>::replace_all (T new_value)
{
  value = new_value;
  if (left != NULL)
    left->replace_all (new_value);
  if (right != NULL)
    right->replace_all (new_value);
}
