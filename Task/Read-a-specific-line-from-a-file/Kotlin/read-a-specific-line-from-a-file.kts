// version 1.1.2

import java.io.File

fun main(args: Array<String>) {
    /* The following code reads the whole file into memory
       and so should not be used for large files
       which should instead be read line by line until the
       desired line is reached */

    val lines = File("input.txt").readLines()
    if (lines.size < 7)
        println("There are only ${lines.size} lines in the file")
    else {
        val line7 = lines[6].trim()
        if (line7.isEmpty())
            println("The seventh line is empty")
        else
            println("The seventh line is : $line7")
    }
}

/* Note that 'input.txt' contains the eight lines:
Line 1
Line 2
Line 3
Line 4
Line 5
Line 6
Line 7
Line 8
*/
