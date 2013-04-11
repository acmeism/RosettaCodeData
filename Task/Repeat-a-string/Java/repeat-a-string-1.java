public static String repeat(String str, int times){
   StringBuilder ret = new StringBuilder();
   for(int i = 0;i < times;i++) ret.append(str);
   return ret.toString();
}

public static void main(String[] args){
  System.out.println(repeat("ha", 5));
}
