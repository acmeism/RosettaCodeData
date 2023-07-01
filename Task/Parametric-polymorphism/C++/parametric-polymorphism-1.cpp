template<class T>
class tree
{
  T value;
  tree *left;
  tree *right;
public:
  void replace_all (T new_value);
};
