import java.util.Scanner

object Subleq extends App {
  val mem = Array(15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1,
    'H', 'e', 'l', 'l', 'o', ',', ' ', 'w', 'o', 'r', 'l', 'd', '!', 10, 0)
  val input = new Scanner(System.in)
  var instructionPointer = 0

  do {
    val (a, b) = (mem(instructionPointer), mem(instructionPointer + 1))
    if (a == -1) mem(b) = input.nextInt
    else if (b == -1) print(f"${mem(a)}%c")
    else {
      mem(b) -= mem(a)
      if (mem(b) < 1) instructionPointer = mem(instructionPointer + 2) - 3
    }
    instructionPointer += 3
  } while (instructionPointer >= 0)
}
