import org.codehaus.groovy.runtime.DefaultGroovyMethods

class ComplexCategory {
    static Complex getI (Number a) { [0, a] as Complex }

    static Complex plus (Number a, Complex b) { b + a }
    static Complex minus (Number a, Complex b) { -b + a }
    static Complex multiply (Number a, Complex b) { b * a }
    static Complex div (Number a, Complex b) { ([a] as Complex) / b  }
    static Complex power (Number a, Complex b) { ([a] as Complex) ** b }

    static <N extends Number,T> T asType (N a, Class<T> type) {
        type == Complex \
            ? [a as Number] as Complex
            : DefaultGroovyMethods.asType(a, type)
    }
}
