public static boolean perf(int n){
	int sum= 0;
	for(int i= 1;i < n;i++){
		if(n % i == 0){
			sum+= i;
		}
	}
	return sum == n;
}
