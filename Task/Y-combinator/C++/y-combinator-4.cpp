template <typename A, typename B>
struct YFunctor {
  const std::function<std::function<B(A)>(std::function<B(A)>)> f;
  YFunctor(std::function<std::function<B(A)>(std::function<B(A)>)> _f) : f(_f) {}
  B operator()(A x) const {
    return f(*this)(x);
  }
};

template <typename A, typename B>
std::function<B(A)> Y (std::function<std::function<B(A)>(std::function<B(A)>)> f) {
  return YFunctor<A,B>(f);
}
