public class FizzBuzz {
    public static void main(String[] args) {
        int number = 1;
        while (number <= 100) {
            System.out.println(number % 15 == 0 ? "FizzBuzz" : number % 3 == 0 ? "Fizz" : number % 5 == 0 ? "Buzz" : number);
            number++;
        }
    }
}
