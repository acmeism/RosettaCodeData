#include <iostream>
#include <functional>

template <typename T>
std::function<T(T)> makeAccumulator(T sum) {
	return [=](T increment) mutable {
		return sum += increment;
	};
}

int main() {
	auto acc = makeAccumulator<float>(1);
	acc(5);
	makeAccumulator(3);
	std::cout << acc(2.3) << std::endl;
	return 0;
}
