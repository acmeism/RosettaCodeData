public class ShowAsciiTable {

    public static void main(String[] args) {
        for ( int i = 32 ; i <= 127 ; i++ ) {
            if ( i == 32 || i == 127 ) {
                String s = i == 32 ? "Spc" : "Del";
                System.out.printf("%3d: %s ", i, s);
            }
            else {
                System.out.printf("%3d: %c   ", i, i);
            }
            if ( (i-1) % 6 == 0 ) {
                System.out.println();
            }
        }
    }

}
