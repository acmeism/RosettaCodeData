// Generate Kaprekar Numbers using Casting Out Nines Generator
//
// Nigel Galloway. July 13th., 2012
//
#include <cmath>
int main() {
	const ran r(10);
	int Paddy_cnt = 0;
	for (int nz=1; nz<=6; nz++)
		for (unsigned long long int k : co9(std::pow(r.base,nz-1),std::pow(r.base,nz)-1,&r))
			for (int n=nz; n<nz*2; n++) {
				const unsigned long long int B = pow(r.base,n);
				const double nr = k*(B-k)/(B-1);
				const int q = k-nr;
				if (k*k==q*B+nr && 0<nr) {
					std::cout << ++Paddy_cnt << ": " << k << " is "  << q << " + " << (int)nr << " and squared is " << k*k << ". It is a member of Residual Set " << k%(r.base-1) << "\n";
			}}
	return 0;
}
