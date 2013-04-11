int fibIter(int n){
	if (n < 2)
		return n;
	
	int last = 0;
	int cur = 1;
	int next;
	
	for (int i = 1; i < n; ++i){
		next = last + cur;
		last = cur;
		cur = next;
	}
	
	return cur;
}
