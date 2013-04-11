public static long grayEncode(long n){
	long result = 0;
	for(int exp = 0; n > 0; n /= 2, exp++){
		long nextHighestBit = (n >> 1) & 1;
		if(nextHighestBit == 1){
			result += ((n & 1) == 0) ? (1 << exp) : 0; //flip the bit
		}else{
			result += (n & 1) * (1 << exp); //"n & 1" is "this bit", don't flip it
		}
	}
	return result;
}
