namespace CatalanNumbers {
  public class CatalanNumberGenerator {
    private static double factorial(double n) {
      if (n == 0)
        return 1;
      return n * factorial(n - 1);
    }

    public double first_method(double n) {
      const double top_multiplier = 2;
      return factorial(top_multiplier * n) / (factorial(n + 1) * factorial(n));
    }

    public double second_method(double n) {
      if (n == 0) {
        return 1;
      }
      double sum = 0;
      double i = 0;
      for (; i <= (n - 1); i++) {
        sum += second_method(i) * second_method((n - 1) - i);
      }
      return sum;
    }

    public double third_method(double n) {
      if (n == 0) {
        return 1;
      }
      return ((2 * (2 * n - 1)) / (n + 1)) * third_method(n - 1);
    }
  }

  void main() {
    CatalanNumberGenerator generator = new CatalanNumberGenerator();
    DateTime initial_time;
    DateTime final_time;
    TimeSpan ts;

    stdout.printf("Direct Method\n");
    stdout.printf(" n%9s\n", "C_n");
    stdout.printf("............\n");
    initial_time = new DateTime.now();
    for (double i = 0; i <= 15; i++) {
      stdout.printf("%2s %8s\n", i.to_string(), Math.ceil(generator.first_method(i)).to_string());
    }
    final_time = new DateTime.now();
    ts = final_time.difference(initial_time);
    stdout.printf("............\n");
    stdout.printf("Time Elapsed: %s μs\n", ts.to_string());

    stdout.printf("\nRecursive Method 1\n");
    stdout.printf(" n%9s\n", "C_n");
    stdout.printf("............\n");
    initial_time = new DateTime.now();
    for (double i = 0; i <= 15; i++) {
      stdout.printf("%2s %8s\n", i.to_string(), Math.ceil(generator.second_method(i)).to_string());
    }
    final_time = new DateTime.now();
    ts = final_time.difference(initial_time);
    stdout.printf("............\n");
    stdout.printf("Time Elapsed: %s μs\n", ts.to_string());

    stdout.printf("\nRecursive Method 2\n");
    stdout.printf(" n%9s\n", "C_n");
    stdout.printf("............\n");
    initial_time = new DateTime.now();
    for (double i = 0; i <= 15; i++) {
      stdout.printf("%2s %8s\n", i.to_string(), Math.ceil(generator.third_method(i)).to_string());
    }
    final_time = new DateTime.now();
    ts = final_time.difference(initial_time);
    stdout.printf("............\n");
    stdout.printf("Time Elapsed: %s μs\n", ts.to_string());

  }
}
