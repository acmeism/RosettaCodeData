public class SquaresCubes {
    public static boolean isPerfectCube(long n) {
        long c = (long)Math.cbrt((double)n);
        return ((c * c * c) == n);
    }

    public static void main(String... args) {
        long n = 1;
        int squareOnlyCount = 0;
        int squareCubeCount = 0;
        while ((squareOnlyCount < 30) || (squareCubeCount < 3)) {
            long sq = n * n;
            if (isPerfectCube(sq)) {
                squareCubeCount++;
                System.out.println("Square and cube: " + sq);
            }
            else {
                squareOnlyCount++;
                System.out.println("Square: " + sq);
            }
            n++;
        }
    }
}
