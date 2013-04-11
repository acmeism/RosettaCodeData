public static String repeat(String str, int times){
   return new String(new char[times]).replace("\0", str);
}
