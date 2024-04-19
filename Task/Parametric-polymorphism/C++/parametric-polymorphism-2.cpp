template<class T>
void tree<T>::replace_all(T new_value) {
  value = new_value;
  if (left != nullptr)
    left->replace_all(new_value);
  if (right != nullptr)
    right->replace_all(new_value);
}
