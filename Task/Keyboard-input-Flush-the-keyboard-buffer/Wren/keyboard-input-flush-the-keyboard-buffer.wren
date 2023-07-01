import "io" for Stdin

System.print("Press some keys followed by enter.")
while (true) {
   var b = Stdin.readByte() // reads and removes a key from the buffer
   System.print("Removed key with code %(b).")
   if (b == 10) break      // buffer will be empty when enter key pressed
}
System.print("Keyboard buffer is now empty.")
