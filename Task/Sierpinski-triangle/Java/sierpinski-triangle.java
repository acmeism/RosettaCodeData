public class SierpinskiTriangle {

    public static void main(String[] args) {
        System.out.println(getSierpinskiTriangle(4));
    }

    private static final String getSierpinskiTriangle(int n) {
        if ( n == 0 ) {
            return "*";
        }

        String s = getSierpinskiTriangle(n-1);
        String [] split = s.split("\n");
        int length = split.length;

        //  Top triangle
        StringBuilder sb = new StringBuilder();
        String top = buildSpace((int)Math.pow(2, n-1));
        for ( int i = 0 ; i < length ;i++ ) {
            sb.append(top);
            sb.append(split[i]);
            sb.append("\n");
        }

        //  Two triangles side by side
        for ( int i = 0 ; i < length ;i++ ) {
            sb.append(split[i]);
            sb.append(buildSpace(length-i));
            sb.append(split[i]);
            sb.append("\n");
        }
        return sb.toString();
    }

    private static String buildSpace(int n) {
        StringBuilder sb = new StringBuilder();
        while ( n > 0 ) {
            sb.append(" ");
            n--;
        }
        return sb.toString();
    }

}
