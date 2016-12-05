def rand = new Random() // java.util.Random
def range = 1..100 // Range (inclusive)
def number = rand.nextInt(range.size()) + range.from // get a random number in the range

println "The number is in ${range.toString()}" // print the range

def guess
while (guess != number) { // keep running until correct guess
    try {
        print 'Guess the number: '
        guess = System.in.newReader().readLine() as int // read the guess in as int
        switch (guess) { // check the guess against number
            case { it < number }: println 'Your guess is too low'; break
            case { it > number }: println 'Your guess is too high'; break
            default:              println 'Your guess is spot on!'; break
        }
    } catch (NumberFormatException ignored) { // catches all input that is not a number
        println 'Please enter a number!'
    }
}
