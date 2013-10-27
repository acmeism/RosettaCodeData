#include <iostream>
#include <vector>
using namespace std;

typedef unsigned long native_t;

struct ZPlus_	// unsigned int, represented as digits base 10
{
	vector<native_t> digits_;	// least significant first; value is sum(digits_[i] * 10^i)

	ZPlus_(native_t n) : digits_(1, n)
	{
		while(Sweep());
	}

	bool Sweep()	// clean up digits so they are in [0,9]
	{
		bool changed = false;
		int carry = 0;
		for (auto pd = digits_.begin(); pd != digits_.end(); ++pd)
		{
			*pd += carry;
			carry = *pd / 10;
			*pd -= 10 * carry;
			changed = changed || carry > 0;
		}
		if (carry)
			digits_.push_back(carry);
		return changed || carry > 9;
	}
};

ZPlus_ operator*(const ZPlus_& lhs, const ZPlus_& rhs)
{
	ZPlus_ retval(0);
	// hold enough space
	retval.digits_.resize(lhs.digits_.size() + rhs.digits_.size(), 0ul);
	// accumulate one-digit multiples
	for (size_t ir = 0; ir < rhs.digits_.size(); ++ir)
		for (size_t il = 0; il < lhs.digits_.size(); ++il)
			retval.digits_[ir + il] += rhs.digits_[ir] * lhs.digits_[il];
	// sweep clean and drop zeroes
	while(retval.Sweep());
	while (!retval.digits_.empty() && !retval.digits_.back())
		retval.digits_.pop_back();
	return retval;
}

ostream& operator<<(ostream& dst, const ZPlus_& n)
{
	for (auto pd = n.digits_.rbegin(); pd != n.digits_.rend(); ++pd)
		dst << *pd;
	return dst;
}

int main(int argc, char* argv[])
{
	int p2 = 1;
	ZPlus_ n(2ul);
	for (int ii = 0; ii < 7; ++ii)
	{
		p2 *= 2;
		n = n * n;
		cout << "2^" << p2 << " = " << n << "\n";
	}
	return 0;
}
