public class LawOfCosines {

    public static void main(String[] args) {
        generateTriples(13);
        generateTriples60(10000);
    }

    private static void generateTriples(int max) {
        for ( int coeff : new int[] {0, -1, 1} ) {
            int count = 0;
            System.out.printf("Max side length %d, formula:  a*a + b*b %s= c*c%n", max, coeff == 0 ? "" : (coeff<0 ? "-"  : "+") + " a*b ");
            for ( int a = 1 ; a <= max ; a++ ) {
                for ( int b = 1 ; b <= a ; b++ ) {
                    int val = a*a + b*b + coeff*a*b;
                    int c = (int) (Math.sqrt(val) + .5d);
                    if ( c > max ) {
                        break;
                    }
                    if ( c*c == val ) {
                        System.out.printf("  (%d, %d, %d)%n", a, b ,c);
                        count++;
                    }
                }
            }
            System.out.printf("%d triangles%n", count);
        }
    }

    private static void generateTriples60(int max) {
        int count = 0;
        System.out.printf("%nExtra Credit.%nMax side length %d, sides different length, formula:  a*a + b*b - a*b = c*c%n", max);
        for ( int a = 1 ; a <= max ; a++ ) {
            for ( int b = 1 ; b < a ; b++ ) {
                int val = a*a + b*b - a*b;
                int c = (int) (Math.sqrt(val) + .5d);
                if ( c*c == val ) {
                    count++;
                }
            }
        }
        System.out.printf("%d triangles%n", count);
    }

}
