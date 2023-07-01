template <typename A, typename B>
std::function<B(A)> Y (std::function<std::function<B(A)>(std::function<B(A)>)> f) {
	return [f](A x) {
		return f(Y(f))(x);
	};
}
