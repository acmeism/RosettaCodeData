enum Fruits{
  APPLE(0), BANANA(1), CHERRY(2)
  private final int value;
  fruits(int value) { this.value = value; }
  public int value() { return value; }
}
