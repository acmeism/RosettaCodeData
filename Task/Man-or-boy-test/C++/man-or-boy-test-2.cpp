#include <functional>
#include <iostream>

typedef std::function<int()> F;

static int A(int k, const F &x1, const F &x2, const F &x3, const F &x4, const F &x5)
{
	F B = [=, &k, &B]
	{
		return A(--k, B, x1, x2, x3, x4);
	};

	return k <= 0 ? x4() + x5() : B();
}

static F L(int n)
{
	return [n] { return n; };
}

int main()
{
	std::cout << A(10, L(1), L(-1), L(-1), L(1), L(0)) << std::endl;
	return 0;
}
