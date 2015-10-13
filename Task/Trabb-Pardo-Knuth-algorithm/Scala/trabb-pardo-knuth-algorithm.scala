object TPKa extends App {
    final val numbers = scala.collection.mutable.MutableList[Double]()
    final val in = new java.util.Scanner(System.in)
    while (numbers.length < CAPACITY) {
        print("enter a number: ")
        try {
            numbers += in.nextDouble()
        }
        catch {
            case _: Exception =>
                in.next()
                println("invalid input, try again")
        }
    }

    numbers reverseMap { x =>
        val fx = Math.pow(Math.abs(x), .5D) + 5D * (Math.pow(x, 3))
        if (fx < THRESHOLD)
            print("%8.3f -> %8.3f\n".format(x, fx))
        else
            print("%8.3f -> %s\n".format(x, Double.PositiveInfinity.toString))
    }

    private final val THRESHOLD = 400D
    private final val CAPACITY = 11
}
