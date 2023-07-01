public static boolean isEven(BigInteger i){
    return i.mod(BigInteger.valueOf(2)).equals(BigInteger.ZERO);
}
