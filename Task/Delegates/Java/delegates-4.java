package delegate;

@FunctionalInterface
/* package */ interface $Delegator extends Delegator {
  @Override
  public default Delegator delegate(Thingable thingable) {
    return new_(thingable);
  }

  public static $Delegator new_() {
    return new_(() -> null);
  }

  public static $Delegator new_(Thingable thingable) {
    return () -> thingable;
  }
}
