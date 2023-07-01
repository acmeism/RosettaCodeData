public static BigInteger backToTenBig(String num, int oldBase){
   return new BigInteger(num, oldBase); //takes both uppercase and lowercase letters
}

public static String tenBigToBase(BigInteger num, int newBase){
   return num.toString(newBase);//add .toUpperCase() for capital letters
}
