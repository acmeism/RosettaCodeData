// version 1.0.6

// 'progname.kt' packaged as 'progname.jar'

fun main(args: Array<String>) {
    println(System.getProperty("sun.java.command"))  // may not exist on all JVMs
    println(System.getProperty("java.vm.name"))
}
