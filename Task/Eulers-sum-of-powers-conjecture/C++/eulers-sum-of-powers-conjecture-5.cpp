template<class C_, class LT_> C_ Unique(const C_& src, const LT_& less)
{
	C_ retval(src);
	std::sort(retval.begin(), retval.end(), less);
	retval.erase(unique(retval.begin(), retval.end()), retval.end());
	return retval;
}

template<class I_, class P_> I_ HuntFwd(const I_& hint, const I_& end, const P_& less)	// if less(x) is false, then less(x+1) must also be false
{
	I_ retval(hint);
	int step = 1;
	// expanding phase
	while (end - retval > step)
	{
		I_ test = retval + step;
		if (!less(test))
			break;
		retval = test;
		step <<= 1;
	}
	// contracting phase
	while (step > 1)
	{
		step >>= 1;
		if (end - retval <= step)
			continue;
		I_ test = retval + step;
		if (less(test))
			retval = test;
	}
	if (retval != end && less(retval))
		++retval;
	return retval;
}

bool DPFind(int how_many)
{
	const int MAX = 1000;
	vector<double> pow5(MAX);
	for (int i = 1; i < MAX; i++)
		pow5[i] = (double)i * i * i * i * i;
	vector<pair<double, int>> diffs;
	for (int i = 2; i < MAX; ++i)
	{
		for (int j = 1; j < i; ++j)
			diffs.emplace_back(pow5[i] - pow5[j], j);
	}
	auto firstLess = [](const pair<double, int>& lhs, const pair<double, int>& rhs) { return lhs.first < rhs.first; };
	diffs = Unique(diffs, firstLess);

	for (int x4 = 4; x4 < MAX - 1; ++x4)
	{
		for (int x3 = 3; x3 < x4; ++x3)
		{
			// if (133 * x3 == 110 * x4) continue;	// skip duplicates of first solution
			const auto s2 = pow5[x4] + pow5[x3];
			auto pd = upper_bound(diffs.begin() + 1, diffs.end(), make_pair(s2, 0), firstLess) - 1;
			for (int x2 = 2; x2 < x3; ++x2)
			{
				const auto sum = s2 + pow5[x2];
				pd = HuntFwd(pd, diffs.end(), [&](decltype(pd) it){ return it->first < sum; });
				if (pd != diffs.end() && pd->first == sum && pd->second < x3)	// find each solution only once
				{
					const double y = pow(pd->first + pow5[pd->second], 0.2);
					cout << x4 << " " << x3 << " " << x2 << " " << pd->second << " -> " << static_cast<int>(y + 0.5) << "\n";
					if (--how_many <= 0)
						return true;
				}
			}
		}
	}
	return false;
}
