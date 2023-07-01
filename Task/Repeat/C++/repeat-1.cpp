template <typename Function>
void repeat(Function f, unsigned int n) {
 for(unsigned int i=n; 0<i; i--)
  f();
}
