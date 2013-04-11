int fibRec(int n){
	if (n < 2)
		return n;
	else
		return fibRec(n - 1) + fibRec(n - 2);
}
