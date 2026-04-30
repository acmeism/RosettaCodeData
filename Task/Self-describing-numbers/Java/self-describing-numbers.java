public class SelfDescribingNumbers{
    public static boolean isSelfDescribing(int a){
        String s = Integer.toString(a);
        for(int i = 0; i < s.length(); i++){
            int b = (int) s.charAt(i) - (int) '0';
            int count = 0;
            for(int j = 0; j < s.length(); j++){
                if( i == (int) s.charAt(j) - (int) '0' ){
                    count++;
                }
                if (count > b) return false;
            }
            if(count != b) return false;
        }
        return true;
    }

    public static void main(String[] args){
        for(int i = 0; i < 100000000; i++){
            if(isSelfDescribing(i)){
                System.out.println(i);
             }
        }
    }
}
