public class PrintIdentityMatrix {

    public static void main(String[] args) {
        int n = 5;
        int[][] array = new int[n][n];

        IntStream.range(0, n).forEach(i -> array[i][i] = 1);

        Arrays.stream(array)
                .map((int[] a) -> Arrays.toString(a))
                .forEach(System.out::println);
    }
}
