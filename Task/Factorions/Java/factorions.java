public class Factorion {
    public static void main(String [] args){
        System.out.println("Base 9:");
        for(int i = 1; i <= 1499999; i++){
            String iStri = String.valueOf(i);
            int multiplied = operate(iStri,9);
            if(multiplied == i){
                System.out.print(i + "\t");
            }
        }
        System.out.println("\nBase 10:");
        for(int i = 1; i <= 1499999; i++){
            String iStri = String.valueOf(i);
            int multiplied = operate(iStri,10);
            if(multiplied == i){
                System.out.print(i + "\t");
            }
        }
        System.out.println("\nBase 11:");
        for(int i = 1; i <= 1499999; i++){
            String iStri = String.valueOf(i);
            int multiplied = operate(iStri,11);
            if(multiplied == i){
                System.out.print(i + "\t");
            }
        }
        System.out.println("\nBase 12:");
        for(int i = 1; i <= 1499999; i++){
            String iStri = String.valueOf(i);
            int multiplied = operate(iStri,12);
            if(multiplied == i){
                System.out.print(i + "\t");
            }
        }
    }
    public static int factorialRec(int n){
        int result = 1;
        return n == 0 ? result : result * n * factorialRec(n-1);
    }

    public static int operate(String s, int base){
        int sum = 0;
        String strx = fromDeci(base, Integer.parseInt(s));
        for(int i = 0; i < strx.length(); i++){
            if(strx.charAt(i) == 'A'){
                sum += factorialRec(10);
            }else if(strx.charAt(i) == 'B') {
                sum += factorialRec(11);
            }else if(strx.charAt(i) == 'C') {
                sum += factorialRec(12);
            }else {
                sum += factorialRec(Integer.parseInt(String.valueOf(strx.charAt(i)), base));
            }
        }
        return sum;
    }
    // Ln 57-71 from Geeks for Geeks @ https://www.geeksforgeeks.org/convert-base-decimal-vice-versa/
    static char reVal(int num) {
        if (num >= 0 && num <= 9)
            return (char)(num + 48);
        else
            return (char)(num - 10 + 65);
    }
    static String fromDeci(int base, int num){
        StringBuilder s = new StringBuilder();
        while (num > 0) {
            s.append(reVal(num % base));
            num /= base;
        }
        return new String(new StringBuilder(s).reverse());
    }
}
