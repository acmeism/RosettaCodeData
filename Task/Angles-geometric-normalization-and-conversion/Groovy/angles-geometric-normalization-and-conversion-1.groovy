import java.lang.reflect.Constructor

abstract class Angle implements Comparable<? extends Angle> {
    double value

    Angle(double value = 0) { this.value = normalize(value) }

    abstract Number unitCircle()
    abstract String unitName()

    Number normalize(double n) { n % this.unitCircle() }

    def <B extends Angle> B asType(Class<B> bClass){
        if (bClass == this.class) return this
        bClass.getConstructor(Number.class).newInstance(0).tap {
            value = this.value * unitCircle() / this.unitCircle()
        }
    }

    String toString() {
        "${String.format('%14.8f',value)}${this.unitName()}"
    }

    int hashCode() {
        value.hashCode() + 17 * unit().hashCode()
    }

    int compareTo(Angle that) {
        this.value * that.unitCircle() <=> that.value * this.unitCircle()
    }

    boolean equals(that) {
        this.is(that)            ? true
        : that instanceof Angle  ? (this <=> that) == 0
        : that instanceof Number ? this.value == this.normalize(that)
                                 : super.equals(that)
    }
}

class Degrees extends Angle {
    static final int UNIT_CIRCLE = 360
    Number unitCircle() { UNIT_CIRCLE }
    static final String UNIT = "º    "
    String unitName() { UNIT }
    Degrees(Number value = 0) { super(value) }
}

class Gradians extends Angle {
    static final int UNIT_CIRCLE = 400
    Number unitCircle() { UNIT_CIRCLE }
    static final String UNIT = " grad"
    String unitName() { UNIT }
    Gradians(Number value = 0) { super(value) }
}

class Mils extends Angle {
    static final int UNIT_CIRCLE = 6400
    Number unitCircle() { UNIT_CIRCLE }
    static final String UNIT = " mil "
    String unitName() { UNIT }
    Mils(Number value = 0) { super(value) }
}

class Radians extends Angle {
    static final double UNIT_CIRCLE = Math.PI*2
    Number unitCircle() { UNIT_CIRCLE }
    static final String UNIT = " rad "
    String unitName() { UNIT }
    Radians(Number value = 0) { super(value) }
}
