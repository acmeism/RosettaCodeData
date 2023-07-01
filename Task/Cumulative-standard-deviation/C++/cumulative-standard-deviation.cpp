#include <assert.h>
#include <cmath>
#include <vector>
#include <iostream>

template<int N> struct MomentsAccumulator_
{
	std::vector<double> m_;
	MomentsAccumulator_() : m_(N + 1, 0.0) {}
	void operator()(double v)
	{
		double inc = 1.0;
		for (auto& mi : m_)
		{
			mi += inc;
			inc *= v;
		}
	}
};

double Stdev(const std::vector<double>& moments)
{
	assert(moments.size() > 2);
	assert(moments[0] > 0.0);
	const double mean = moments[1] / moments[0];
	const double meanSquare = moments[2] / moments[0];
	return sqrt(meanSquare - mean * mean);
}

int main(void)
{
	std::vector<int> data({ 2, 4, 4, 4, 5, 5, 7, 9 });
	MomentsAccumulator_<2> accum;
	for (auto d : data)
	{
		accum(d);
		std::cout << "Running stdev:  " << Stdev(accum.m_) << "\n";
	}
}
