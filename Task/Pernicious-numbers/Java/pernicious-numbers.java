public class Pernicious{
    //very simple isPrime since x will be <= Long.SIZE
    public static boolean isPrime(int x){
        if(x < 2) return false;
        for(int i = 2; i < x; i++){
            if(x % i == 0) return false;
        }
        return true;
    }

    public static int popCount(long x){
        return Long.bitCount(x);
    }

    public static void main(String[] args){
        for(long i = 1, n = 0; n < 25; i++){
            if(isPrime(popCount(i))){
                System.out.print(i + " ");
                n++;
            }
        }

        System.out.println();

        for(long i = 888888877; i <= 888888888; i++){
            if(isPrime(popCount(i))) System.out.print(i + " ");
        }
    }
}
