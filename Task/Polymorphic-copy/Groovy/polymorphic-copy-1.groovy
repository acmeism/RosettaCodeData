class T implements Cloneable {
    String property
    String name() { 'T' }
    T copy() {
        try { super.clone() }
        catch(CloneNotSupportedException e) { null }
    }
    @Override
    boolean equals(that) { this.name() == that?.name() && this.property == that?.property }
}

class S extends T {
    @Override String name() { 'S' }
}
