import java.util.function.Function;

@FunctionalInterface
public interface SelfApplicable<OUTPUT> extends Function<SelfApplicable<OUTPUT>, OUTPUT> {
  public default OUTPUT selfApply() {
    return apply(this);
  }
}
