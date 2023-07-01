#include <chrono>
#include <iostream>
#include <gmpxx.h>
#include <functional>
#include <memory>

template<class T>
class Lazy {
public:
	T _v;
private:
	std::function<T()> _f;

public:
	explicit Lazy(std::function<T()> thnk)
		: _v(T()), _f(thnk) {};
	T value() { // not thread safe!
		if (this->_f != nullptr) {
			this->_v = this->_f();
			this->_f = nullptr;
		}
		return this->_v;
	}
};

template<class T>
class LazyList {
public:
	T head;
	std::shared_ptr<Lazy<LazyList<T>>> tail;
	LazyList(): head(T()) {} // only used in initializing Lazy...
	LazyList(T head, std::function<LazyList<T>()> thnk)
		: head(head), tail(std::make_shared<Lazy<LazyList<T>>>(thnk)) {}
	// default Copy/Move constructors and assignment operators seem to work well enough
	bool isEmpty() { return this->tail == nullptr; }
};

typedef std::shared_ptr<mpz_class> PBI;
typedef LazyList<PBI> LL;
typedef std::function<LL(LL)> FLL2LL;

LL merge(LL a, LL b) {
	auto ha = a.head; auto hb = b.head;
	if (*ha < *hb) {
		return LL(ha, [=]() { return merge(a.tail->value(), b); });
	} else {
		return LL(hb, [=]() { return merge(a, b.tail->value()); });
	}
}

LL smult(int m, LL s) {
	const auto im = mpz_class(m);
	const auto psmlt =
			std::make_shared<FLL2LL>([](LL ss) { return ss; });
	*psmlt = [=](LL ss) {
		return LL(std::make_shared<mpz_class>(*ss.head * im),
				  [=]() { return (*psmlt)(ss.tail->value()); });
	};
	return (*psmlt)(s); // worker wrapper pattern with recursive closure as worker...
}

LL u(LL s, int n) {
	const auto r = std::make_shared<LL>(LL()); // interior mutable...
	*r = smult(n, LL(std::make_shared<mpz_class>(1), [=]() { return *r; }));
	if (!s.isEmpty()) { *r = merge(s, *r); }
	return *r;
}

LL hammings() {
	auto r = LL();
	for (auto pn : std::vector<int>({5, 3, 2})) {
		r = u(r, pn);
	}
	return LL(std::make_shared<mpz_class>(1), [=]() { return r; });
}

int main() {
	auto hmgs = hammings();
	for (auto i = 0; i < 20; ++i) {
		std::cout << *hmgs.head << " ";
		hmgs = hmgs.tail->value();
	}
	std::cout << "\n";

	hmgs = hammings();
	for (auto i = 1; i < 1691; ++i) hmgs = hmgs.tail->value();
	std::cout << *hmgs.head << "\n";

	auto start = std::chrono::steady_clock::now();
	hmgs = hammings();
	for (auto i = 1; i < 1000000; ++i) hmgs = hmgs.tail->value();
	auto stop = std::chrono::steady_clock::now();

	auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);
	std::cout << *hmgs.head << " in " << ms.count() << "milliseconds.\n";
}
