package delegate;

// Example usage
// Memory management ignored for simplification
public interface DelegateTest {
  public static String thingable() {
    return "method reference implementation";
  }

  public static void main(String... arguments) {
    // Without a delegate:
    Delegator d1 = Delegator.new_();
    assert d1.operation().equals("default implementation");

    // With a delegate:
    Delegator d2 = d1.delegate(new Delegate());
    assert d2.operation().equals("delegate implementation");

    // Same as the above, but with an anonymous class:
    Delegator d3 = d2.delegate(new Thingable() {
      @Override
      public String thing() {
        return "anonymous delegate implementation";
      }
    });
    assert d3.operation().equals("anonymous delegate implementation");

    // Same as the above, but with a method reference:
    Delegator d4 = d3.delegate(DelegateTest::thingable);
    assert d4.operation().equals("method reference implementation");

    // Same as the above, but with a lambda expression:
    Delegator d5 = d4.delegate(() -> "lambda expression implementation");
    assert d5.operation().equals("lambda expression implementation");
  }
}
