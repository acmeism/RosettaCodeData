static void Main(string[] args)
{
    //There will be a 3 second pause between each cursor movement.
    Console.Write("\n\n\n\n     Cursor is here -->   ");
    System.Threading.Thread.Sleep(3000);
    Console.CursorLeft = Console.CursorLeft - 1; //Console.CursorLeft += -1 is an alternative.
    System.Threading.Thread.Sleep(3000);
    Console.CursorLeft = Console.CursorLeft + 1;
    System.Threading.Thread.Sleep(3000);
    Console.CursorTop = Console.CursorTop - 1;
    System.Threading.Thread.Sleep(3000);
    Console.CursorTop = Console.CursorTop + 1;
    System.Threading.Thread.Sleep(3000);
    Console.CursorLeft = 0; //Move the cursor far left.
    System.Threading.Thread.Sleep(3000);
    Console.CursorLeft = Console.BufferWidth - 1;
    /* BufferWidth represents the number of characters wide the console area is.
        * The exact value may vary on different systems.
        * As the cursor position is a 0 based index we must subtract 1 from buffer width or we move the cursor out of bounds.
        * In some cases WindowWidth may be preferable (however in this demonstration window and buffer should be the same).
        */
    System.Threading.Thread.Sleep(3000);
    Console.SetCursorPosition(0,0); //I have used an alternative method for moving the cursor here which I feel is cleaner for the task at hand.
    System.Threading.Thread.Sleep(3000);
    Console.SetCursorPosition(Console.BufferWidth-1, Console.WindowHeight-1); //Buffer height is usually longer than the window so window has been used instead.
    System.Threading.Thread.Sleep(3000);
}
