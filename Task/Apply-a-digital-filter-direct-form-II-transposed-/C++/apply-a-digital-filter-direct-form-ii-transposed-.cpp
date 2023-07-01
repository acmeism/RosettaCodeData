#include <vector>
#include <iostream>
using namespace std;

void Filter(const vector<float> &b, const vector<float> &a, const vector<float> &in, vector<float> &out)
{

	out.resize(0);
	out.resize(in.size());

	for(int i=0; i < in.size(); i++)
	{
		float tmp = 0.;
		int j=0;
		out[i] = 0.f;
		for(j=0; j < b.size(); j++)
		{
			if(i - j < 0) continue;
			tmp += b[j] * in[i-j];
		}

		for(j=1; j < a.size(); j++)
		{
			if(i - j < 0) continue;
			tmp -= a[j]*out[i-j];
		}
		
		tmp /= a[0];
		out[i] = tmp;
	}
}

int main()
{
	vector<float> sig = {-0.917843918645,0.141984778794,1.20536903482,0.190286794412,-0.662370894973,-1.00700480494,\
		-0.404707073677,0.800482325044,0.743500089861,1.01090520172,0.741527555207,\
		0.277841675195,0.400833448236,-0.2085993586,-0.172842103641,-0.134316096293,\
		0.0259303398477,0.490105989562,0.549391221511,0.9047198589};

	//Constants for a Butterworth filter (order 3, low pass)
	vector<float> a = {1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17};
	vector<float> b = {0.16666667, 0.5, 0.5, 0.16666667};
	
	vector<float> result;
	Filter(b, a, sig, result);

	for(size_t i=0;i<result.size();i++)
		cout << result[i] << ",";
	cout << endl;			

	return 0;
}
