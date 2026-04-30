#include <functional>
#include <iostream>

typedef std::function_ref<int()> F;

static int A(int k, F x1, F x2, F x3, F x4, F x5)
{
	auto B = [&](this const auto& B) -> int {
		return A(--k, B, x1, x2, x3, x4);
	};
	return k <= 0 ? x4() + x5() : B();
}

static auto L(int n)
{
	return [n] { return n; };
}

int main()
{
	std::cout << A(10, L(1), L(-1), L(-1), L(1), L(0)) << std::endl;
}
