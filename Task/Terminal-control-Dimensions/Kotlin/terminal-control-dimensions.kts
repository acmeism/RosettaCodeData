// version 1.1.2

/*
    I needed to execute the terminal command: 'export COLUMNS LINES'
    before running this program for it to work (returned 'null' sizes otherwise).
*/

fun main(args: Array<String>) {
    val lines = System.getenv("LINES")
    val columns = System.getenv("COLUMNS")
    println("Lines   = $lines")
    println("Columns = $columns")
}
