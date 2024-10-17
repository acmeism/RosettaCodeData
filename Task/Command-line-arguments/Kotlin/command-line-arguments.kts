fun main(args: Array<String>) {
     println("There are " + args.size + " arguments given.")
     args.forEachIndexed { i, a -> println("The argument #${i+1} is $a and is at index $i") }
}
