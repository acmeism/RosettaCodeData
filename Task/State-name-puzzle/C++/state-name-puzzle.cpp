#include <stdio.h>
#include <cstdlib>
#include <string>
#include <vector>
#include <algorithm>
#include <iostream>
using namespace std;

// some common code
template<class C_, class LT_> C_ Unique(const C_& src, const LT_& less)
{
	C_ retval(src);
	std::sort(retval.begin(), retval.end(), less);
	retval.erase(unique(retval.begin(), retval.end()), retval.end());
	return retval;
}
template<class C_> C_ Unique(const C_& src)
{
	return Unique(src, std::less<C_::value_type>());
}

#define USE_FAKES 1

vector<string> states = Unique(vector<string>({
#if USE_FAKES
	"Slender Dragon", "Abalamara",
#endif
	"Alabama", "Alaska", "Arizona", "Arkansas",
	"California", "Colorado", "Connecticut",
	"Delaware",
	"Florida", "Georgia", "Hawaii",
	"Idaho", "Illinois", "Indiana", "Iowa",
	"Kansas", "Kentucky", "Louisiana",
	"Maine", "Maryland", "Massachusetts", "Michigan",
	"Minnesota", "Mississippi", "Missouri", "Montana",
	"Nebraska", "Nevada", "New Hampshire", "New Jersey",
	"New Mexico", "New York", "North Carolina", "North Dakota",
	"Ohio", "Oklahoma", "Oregon",
	"Pennsylvania", "Rhode Island",
	"South Carolina", "South Dakota", "Tennessee", "Texas",
	"Utah", "Vermont", "Virginia",
	"Washington", "West Virginia", "Wisconsin", "Wyoming"
}));

struct CountedPair_
{
	string name_;
	vector<unsigned char> count_;

	void Add(const string& s)
	{
		for (auto c : s)
		{
			if (c >= 'a' && c <= 'z') ++count_[c - 'a'];
			if (c >= 'A' && c <= 'Z') ++count_[c - 'A'];
		}
	}

	CountedPair_(const string& s1, const string& s2) : name_(s1 + " + " + s2), count_(26, 0u)
	{
		Add(s1); Add(s2);
	}
};

bool operator<(const CountedPair_& lhs, const CountedPair_& rhs)
{
	const int s1 = lhs.name_.size(), s2 = rhs.name_.size();
	return s1 == s2
		? lexicographical_compare(lhs.count_.begin(), lhs.count_.end(), rhs.count_.begin(), rhs.count_.end())
		: s1 < s2;
}

bool operator==(const CountedPair_& lhs, const CountedPair_& rhs)
{
	return lhs.name_.size() == rhs.name_.size()
		&& lhs.count_ == rhs.count_;
}

void FindPairs()
{
	const int n_states = states.size();

	vector<CountedPair_> pairs;
	for (int i = 0; i < n_states; i++)
		for (int j = 0; j < i; j++)
			pairs.emplace_back(states[i], states[j]);
	sort(pairs.begin(), pairs.end());

	auto start = pairs.begin();
	for (;;)
	{
		auto match = adjacent_find(start, pairs.end());
		if (match == pairs.end())
			break;
		auto next = match + 1;
		cout << match->name_ << " => " << next->name_ << "\n";
		start = next;
	}
}

int main(void)
{
	FindPairs();
	return 0;
}
