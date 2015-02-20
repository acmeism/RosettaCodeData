import org.codehaus.groovy.runtime.DefaultGroovyMethods

class RationalCategory {
    static Rational plus (Number a, Rational b) { ([a] as Rational) + b }
    static Rational minus (Number a, Rational b) { ([a] as Rational) - b }
    static Rational multiply (Number a, Rational b) { ([a] as Rational) * b }
    static Rational div (Number a, Rational b) { ([a] as Rational) / b  }

    static <T> T asType (Number a, Class<T> type) {
        type == Rational \
            ? [a] as Rational
                : DefaultGroovyMethods.asType(a, type)
    }
}
