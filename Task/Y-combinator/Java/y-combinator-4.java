import java.util.function.Function;
import java.util.function.UnaryOperator;

@FunctionalInterface
public interface FixedPoint<FUNCTION> extends Function<UnaryOperator<FUNCTION>, FUNCTION> {}
