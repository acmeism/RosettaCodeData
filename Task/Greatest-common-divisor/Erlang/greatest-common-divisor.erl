gcd(0,B) -> abs(B);
gcd(A,0) -> abs(A);
gcd(A,B) when A > B -> gcd(B, A rem B);
gcd(A,B) -> gcd(A, B rem A).
