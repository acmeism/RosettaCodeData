  Console.err.println ("Err not deviated")
  Console.setErr(Console.out)
  Console.err.println ("Err deviated")
  Console.setErr(Console.err) // Reset to normal
