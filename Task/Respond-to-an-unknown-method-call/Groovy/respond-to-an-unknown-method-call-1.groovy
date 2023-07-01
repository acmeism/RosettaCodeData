class MyObject {
    def foo() {
        println 'Invoked foo'
    }
    def methodMissing(String name, args) {
        println "Invoked missing method $name$args"
    }
}
