import java.security.SecureRandom

object RandomExample extends App {
  new SecureRandom {
    val newSeed: Long = this.nextInt().toLong * this.nextInt()
    this.setSeed(newSeed) // reseed using the previous 2 random numbers
    println(this.nextInt()) // get random 32-bit number and print it
  }
}
