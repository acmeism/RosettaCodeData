// the simple version:
System.Console.Write("\a"); // will beep
System.Threading.Thread.Sleep(1000); // will wait for 1 second
System.Console.Beep(); // will beep a second time
System.Threading.Thread.Sleep(1000);

// System.Console.Beep() also accepts (int)hertz and (int)duration in milliseconds:
System.Console.Beep(440, 2000); // default "concert pitch" for 2 seconds
