Func Y(FuncFunc f) {
  return ^(int x) {
    return f(Y(f))(x);
  };
}
