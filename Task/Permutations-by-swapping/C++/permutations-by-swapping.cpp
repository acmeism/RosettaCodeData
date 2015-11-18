#include <iostream>
#include <vector>

using namespace std;

vector<int> UpTo(int n, int offset = 0)
{
	vector<int> retval(n);
	for (int ii = 0; ii < n; ++ii)
		retval[ii] = ii + offset;
	return retval;
}

struct JohnsonTrotterState_
{
	vector<int> values_;
	vector<int> positions_;	// size is n+1, first element is not used
	vector<bool> directions_;
	int sign_;

	JohnsonTrotterState_(int n) : values_(UpTo(n, 1)), positions_(UpTo(n + 1, -1)), directions_(n + 1, false), sign_(1) {}

	int LargestMobile() const	// returns 0 if no mobile integer exists
	{
		for (int r = values_.size(); r > 0; --r)
		{
			const int loc = positions_[r] + (directions_[r] ? 1 : -1);
			if (loc >= 0 && loc < values_.size() && values_[loc] < r)
				return r;
		}
		return 0;
	}

	bool IsComplete() const { return LargestMobile() == 0; }

	void operator++()	// implement Johnson-Trotter algorithm
	{
		const int r = LargestMobile();
		const int rLoc = positions_[r];
		const int lLoc = rLoc + (directions_[r] ? 1 : -1);
		const int l = values_[lLoc];
		// do the swap
		swap(values_[lLoc], values_[rLoc]);
		swap(positions_[l], positions_[r]);
		sign_ = -sign_;
		// change directions
		for (auto pd = directions_.begin() + r + 1; pd != directions_.end(); ++pd)
			*pd = !*pd;
	}
};

int main(void)
{
	JohnsonTrotterState_ state(4);
	do
	{
		for (auto v : state.values_)
			cout << v << " ";
		cout << "\n";
		++state;
	} while (!state.IsComplete());
}
