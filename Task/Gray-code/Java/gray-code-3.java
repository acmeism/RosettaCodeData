public static BigInteger grayDecode(BigInteger n){
	String nBits = n.toString(2);
	String result = nBits.substring(0, 1);
	for(int i = 1; i < nBits.length(); i++){
		//bin[i] = gray[i] ^ bin[i-1]

		//XOR with characters
		result += nBits.charAt(i) != result.charAt(i - 1) ? "1" : "0";
	}
	return new BigInteger(result, 2);
}
