bool find()
{
	const auto MAX = 250;
	vector<double> pow5(MAX);
	for (auto i = 1; i < MAX; i++)
		pow5[i] = (double)i * i * i * i * i;
	auto rs = 5;
	for (auto x0 = 1; x0 < MAX; x0++) {
		for (auto x1 = 1; x1 < x0; x1++) {
			for (auto x2 = 1; x2 < x1; x2++) {
				auto s2 = pow5[x0] + pow5[x1] + pow5[x2];
				while (rs > 0 && pow5[rs] > s2) --rs;
				for (auto x3 = 1; x3 < x2; x3++) {
					auto sum = s2 + pow5[x3];
					while (rs < MAX - 1 && pow5[rs] < sum) ++rs;
					if (pow5[rs] == sum)
					{
						cout << x0 << " " << x1 << " " << x2 << " " << x3 << " " << pow(sum, 1.0 / 5.0) << endl;
						return true;
					}
				}
			}
		}
	}
	// not found
	return false;
}
