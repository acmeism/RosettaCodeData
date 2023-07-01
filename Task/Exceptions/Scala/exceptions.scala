//Defining exceptions
class AccountBlockException extends Exception
class InsufficientFundsException(val amount: Double) extends Exception

class CheckingAccount(number: Int, var blocked: Boolean = false, var balance: Double = 0.0) {
  def deposit(amount: Double) { // Throwing an exception 1
    if (blocked) throw new AccountBlockException
    balance += amount
  }

  def withdraw(amount: Double) { // Throwing an exception 2
    if (blocked) throw new AccountBlockException
    if (amount <= balance) balance -= amount
    else throw new InsufficientFundsException(amount - balance)
  }
}

object CheckingAccount extends App {

  class ExampleException1 extends Exception

  val c = new CheckingAccount(101)
  println("Depositing $500...")
  try {
    c.deposit(500.00)
    println("\nWithdrawing $100...")
    c.withdraw(100.00)
    println("\nWithdrawing $600...")
    c.withdraw(600.00)
  } catch { // Exception handler
    case ac: InsufficientFundsException => println(s"Sorry, but you are short ${'$'} ${ac.amount}")
    case ac: AccountBlockException      => println("Account blocked.")

    ///////////////////////////// An example of multiple exception handler ////////////////////////
    case e@(_: ExampleException1 |
      _: InterruptedException) => println(s"Out of memory or something else.")

    case e: Exception => e.printStackTrace()
    case _: Throwable => // Exception cached without any action
  } finally println("Have a nice day")
}

object CheckingBlockingAccount extends App {
  val c = new CheckingAccount(102, true)
  println("Depositing $500...")
  try {
    c.deposit(500.00)
    println("\nWithdrawing $100...")
    c.withdraw(100.00)
    println("\nWithdrawing $600...")
    c.withdraw(600.00)
  } catch { // Exception handler
    case ac: InsufficientFundsException => println(s"Sorry, but you are short ${'$'} ${ac.amount}")
    case ac: AccountBlockException      => println("Account blocked.")
    case e: Exception                   => e.printStackTrace()
    case _: Throwable                   =>
  } finally println("Have a nice day")
}

object NotImplementedErrorTest extends App {
  ??? // Throws  scala.NotImplementedError: an implementation is missing
}
