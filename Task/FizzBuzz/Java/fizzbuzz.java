class FizzBuzz {

    public static void main(String[] args) {

        for (int i = 1; i < 101; i++) {
            if ((i % 3 == 0) && (i % 5 == 0)) {
                System.out.print("'fizz buzz', ");
            } else if (i % 3 == 0) {
                System.out.print("'fizz', ");
            } else if (i % 5 == 0) {
                System.out.print("'buzz', ");
            } else {
                System.out.printf("%d, ", i);
            }
        }
    }
}
