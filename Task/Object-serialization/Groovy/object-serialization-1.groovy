class Entity implements Serializable {
    static final serialVersionUID = 3504465751164822571L
    String name = 'Thingamabob'
    public String toString() { return name }
}

class Person extends Entity implements Serializable {
    static final serialVersionUID = -9170445713373959735L
    Person() { name = 'Clement' }
    Person(name) { this.name = name }
}
