import groovy.transform.EqualsAndHashCode

@EqualsAndHashCode
class Vector {
    private List<Number> elements
    Vector(List<Number> e ) {
        if (!e) throw new IllegalArgumentException("A Vector must have at least one element.")
        if (!e.every { it instanceof Number }) throw new IllegalArgumentException("Every element must be a number.")
        elements = [] + e
    }
    Vector(Number... e) { this(e as List) }

    def order() { elements.size() }
    def norm2() { elements.sum { it ** 2 } ** 0.5 }

    def plus(Vector that) {
        if (this.order() != that.order()) throw new IllegalArgumentException("Vectors must be conformable for addition.")
        [this.elements,that.elements].transpose()*.sum() as Vector
    }
    def minus(Vector that) { this + (-that) }
    def multiply(Number that) { this.elements.collect { it * that } as Vector }
    def div(Number that) { this * (1/that) }
    def negative() { this * -1 }

    String toString() { "(${elements.join(',')})" }
}

class VectorCategory {
   static Vector plus (Number a, Vector b) { b + a }
   static Vector minus (Number a, Vector b) { -b + a }
   static Vector multiply (Number a, Vector b) { b * a }
}
