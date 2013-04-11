public static long backToTen(String num, int oldBase){
   return Long.parseLong(num, oldBase); //takes both uppercase and lowercase letters
}

public static String tenToBase(long num, int newBase){
   return Long.toString(num, newBase);//add .toUpperCase() for capital letters
}
