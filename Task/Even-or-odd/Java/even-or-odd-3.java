public static boolean isEven(BigInteger i){
    return i.and(BigInteger.ONE).equals(BigInteger.ZERO);
}
