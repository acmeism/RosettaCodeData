// Generate Kaperkar Numbers
//
// Nigel Galloway. June 24th., 2012
//
#include <iostream>
int main() {
	const int Base = 10;
	const int N = 6;
	int Paddy_cnt = 0;
	for (int nz=1; nz<=N; nz++)
		for (unsigned long long int k=pow((double)Base,nz-1); k<pow((double)Base,nz); k++)
			if ((k*(k-1))%(Base-1) == 0)
				for (int n=nz; n<nz*2; n++){
					const unsigned long long int B = pow((double)Base,n);
					const double nr = k*(B-k)/(B-1);
					const int q = k-nr;
					if ((k*k==q*B+nr && 0<nr)){
						std::cout << std::dec << ++Paddy_cnt << ": " << k << " is "  << q << " + " << (int)nr << " and squared is " << k*k << ". It is a member of Residual Set " << k%(Base-1) << "\n";
						break;
				}}
	return 0;
}
