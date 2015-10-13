template<class T>
void swap(T &lhs, T &rhs){
  T tmp = std::move(lhs);
  lhs = std::move(rhs);
  rhs = std::move(tmp);
}
