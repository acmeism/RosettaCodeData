// Casting Out Nines Generator - Compiles with gcc4.6, MSVC 11, and CLang3
//
// Nigel Galloway. June 24th., 2012
//
#include <iostream>
#include <vector>
struct ran {
	const int base;
	std::vector<int> rs;
	ran(const int base) : base(base) { for (int nz=0; nz<base-1; nz++) if(nz*(nz-1)%(base-1) == 0) rs.push_back(nz); }
};
class co9 {
private:
	const ran* _ran;
	const int _end;
	int _r,_x,_next;
public:
	bool operator!=(const co9& other) const {return operator*() <= _end;}
	co9 begin() const {return *this;}
        co9 end() const {return *this;}
	int operator*() const {return _next;}
	co9(const int start, const int end, const ran* r)
	:_ran(r)
	,_end(end)
	,_r(1)
	,_x(start/_ran->base)
	,_next((_ran->base-1)*_x + _ran->rs[_r])
	{
		while (operator*() < start) operator++();
	}
	const co9& operator++() {
		const int oldr = _r;
		_r = ++_r%_ran->rs.size();
		if (_r<oldr) _x++;
		_next = (_ran->base-1)*_x + _ran->rs[_r];
		return *this;
	}
};

int main() {
	ran r(10);
	for (int i : co9(1,99,&r)) { std::cout << i << ' '; }
	return 0;
}
