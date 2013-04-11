int main() {
	double *N,*D,*d,*q,*r;	// vectors - N / D = q       N % D = r
	int dN, dD, dd, dq, dr;	// degrees of vectors
	int i;					// iterators

// setting the degrees of vectors
	cout << "Enter the degree of N:";
	cin >> dN;
	cout << "Enter the degree of D:";
	cin >> dD;
	dq = dN-dD;
	dr = dN-dD;


// allocation and initialization of vectors
	N=new double [dN+1];					
	cout << "Enter the coefficients of N:"<<endl;
	for ( i = 0; i < dN+1; i++ ) {
		cout << "N[" << i << "]= " << endl;
		cin >> N[i];
	}

	D=new double [dN+1];
	cout << "Enter the coefficients of D:"<<endl;	
	for ( i = 0; i < dD+1; i++ ) {
		cout << "D[" << i << "]= " << endl;
		cin >> D[i];
	}

	d=new double [dN+1];
	for( i = dD+1 ; i < dN+1; i++ ) {
		D[i] = 0;
	}

	q=new double [dq+1];
	for( i = 0 ; i < dq + 1 ; i++ ) {
		q[i] = 0;
	}

	r=new double [dr+1];
	for( i = 0 ; i < dr + 1 ; i++ ) {
		r[i] = 0;
	}

	if( dD < 0) {
		cout << "Degree of D is less than zero. Error!";
	}

	cout << "-- Procedure --" << endl << endl;
	if( dN >= dD ) {
		while(dN >= dD) {
// d equals D shifted right
			for( i = 0 ; i < dN + 1 ; i++ ) {
				d[i] = 0;
			}
			for( i = 0 ; i < dD + 1 ; i++ ) {
				d[i+dN-dD] = D[i];
			}
			dd = dN;

			Print( 'd', dd, d );

// calculating one element of q
			q[dN-dD] = N[dN]/d[dd];

			Print( 'q', dq, q );

// d equals d * q[dN-dD]
			for( i = 0 ; i < dq + 1 ; i++ ) {
				d[i] = d[i] * q[dN-dD];
			}

			Print( 'd', dd, d );

// N equals N - d
			for( i = 0 ; i < dN + 1 ; i++ ) {
				N[i] = N[i] - d[i];
			}
			dN--;

			Print( 'N', dN, N );
			cout << "-----------------------" << endl << endl;

		}

	}

// r equals N
	for( i = 0 ; i < dN + 1 ; i++ ) {
		r[i] = N[i];
	}
	dr = dN;

	cout << "=========================" << endl << endl;
	cout << "-- Result --" << endl << endl;

	Print( 'q', dq, q );
	Print( 'r', dr, r );

// dealocation
	delete [] N;
	delete [] D;
	delete [] d;
	delete [] q;
	delete [] r;
}
