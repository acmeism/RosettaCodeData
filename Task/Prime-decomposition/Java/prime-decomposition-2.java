public static List<BigInteger> primeFactorBig(BigInteger a){
    List<BigInteger> ans = new LinkedList<BigInteger>();
    //loop until we test the number itself or the number is 1
    for (BigInteger i = BigInteger.valueOf(2); i.compareTo(a) <= 0 && !a.equals(BigInteger.ONE);
         i = i.add(BigInteger.ONE)){
        while (a.remainder(i).equals(BigInteger.ZERO) && prime(i)) { //if we have a prime factor
            ans.add(i); //put it in the list
            a = a.divide(i); //factor it out of the number
        }
    }
    return ans;
}
