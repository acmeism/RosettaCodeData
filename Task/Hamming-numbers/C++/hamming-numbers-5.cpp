#include <chrono>
#include <iostream>
#include <vector>
#include <gmpxx.h>

class Hammings {
private:
	const mpz_class _two = 2, _three = 3, _five = 5;
	std::vector<mpz_class> _m = {}, _h = {1};
	mpz_class _x5 = 5, _x53 = 9, _mrg = 3, _x532 = 2;
	int _i = 1, _j = 0;
public:
	Hammings() {_m.reserve(65536); _h.reserve(65536); };
	bool operator!=(const Hammings& other) const { return true; }
	Hammings begin() const { return *this; }
	Hammings end() const { return *this; }
	mpz_class operator*() { return _h.back(); }
	const Hammings& operator++() {
		if (_i > _h.capacity() / 2) {
			_h.erase(_h.begin(), _h.begin() + _i);
			_i = 0;
		}
		if (_x532 < _mrg) {
			_h.push_back(_x532);
			_x532 = _h[_i++] * _two;
		} else {
			_h.push_back(_mrg);
			if (_x53 < _x5) {
				_mrg = _x53;
				_x53 = _m[_j++] * _three;
			} else {
				_mrg = _x5;
				_x5 = _x5 * _five;
			}
			if (_j > _m.capacity() / 2) {
				_m.erase(_m.begin(), _m.begin() + _j);
				_j = 0;
			}
			_m.push_back(_mrg);
		}
		return *this;
	}
};

int main() {
	auto cnt = 1;
	for (auto hmg : Hammings()) {
		if (cnt <= 20) std::cout << hmg << " ";
		if (cnt == 20) std::cout << "\n";
		if (cnt++ >= 1691) {
			std::cout << hmg << "\n";
			break;
		}
	}

	auto start = std::chrono::steady_clock::now();
	hmgs = hammings();
	auto&& hmgitr = Hammings();
	for (auto i = 1; i < 1000000; ++i) ++hmgitr;
	auto stop = std::chrono::steady_clock::now();

	auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(stop - start);
	std::cout << *hmgitr << " in " << ms.count() << "milliseconds.\n";
}
