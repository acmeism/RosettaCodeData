// This is a single line comment

/*
    This is a
    multi-line
    comment
*/

/*
    Multi-line comments
    /*
        can also be nested
    */
    like so
*/

const val CURRENT_VERSION = "1.0.5-2"  // A comment can also be added at the end of a line
const val /* or even in the middle of a line */ NEXT_MAJOR_VERSION = "1.1"

/**
 * This is a documentation comment used by KDoc.
 *
 * It's documenting the main function which is the entry-point to a Kotlin executable.
 *
 * @param [args] A string array containing the command line arguments (if any) passed to the executable
 * @return Implicit return value is Unit which signifies no meaningful return value (like 'void' in java)
 */
fun main(args: Array<String>) {
    println("Current stable version is $CURRENT_VERSION")
    println("Next major version is $NEXT_MAJOR_VERSION")
}
