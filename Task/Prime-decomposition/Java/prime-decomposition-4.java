public static List<BigInteger> primeFactorBig(BigInteger a){
    List<BigInteger> ans = new LinkedList<BigInteger>();

    for(BigInteger divisor = BigInteger.valueOf(2);
    	a.compareTo(ONE) > 0; divisor = divisor.add(ONE))
		while(a.mod(divisor).equals(ZERO)){
			 ans.add(divisor);
			 a = a.divide(divisor);
		}
    return ans;
}
