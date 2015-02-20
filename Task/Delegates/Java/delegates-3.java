package delegate;

import java.util.Optional;

public interface Delegator {
  public Thingable delegate();
  public Delegator delegate(Thingable thingable);

  public static Delegator new_() {
    return $Delegator.new_();
  }

  public default String operation() {
    return Optional.ofNullable(delegate())
      .map(Thingable::thing)
      .orElse("default implementation")
    ;
  }
}
