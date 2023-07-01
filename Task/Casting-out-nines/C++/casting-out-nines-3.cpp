struct ran {
	const int base;
	std::vector<int> rs;
	ran(const int base) : base(base) { for (int nz=0; nz<base-1; nz++) if(SumDigits(nz) == SumDigits(nz*nz)) rs.push_back(nz); }
};
