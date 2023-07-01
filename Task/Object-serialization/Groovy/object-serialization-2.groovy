File objectStore = new File('objectStore.ser')
if (objectStore.exists()) { objectStore.delete() }
assert ! objectStore.exists()
def os
try {
    os = objectStore.newObjectOutputStream()
    os << new Person()
    os << 10.5
    os << new Person('Cletus')
    os << new Date()
    os << new Person('Pious')
    os << java.awt.Color.RED
    os << new Person('Linus')
    os << 'just random garbage'
    os << new Person('Lucy')
    os << ['lists', 'are', 'serializable']
    os << new Person('Schroeder')
} catch (e) { throw new Exception(e) } finally { os?.close() }
assert objectStore.exists()
