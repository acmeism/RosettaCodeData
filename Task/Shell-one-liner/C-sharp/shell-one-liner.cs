> Add-Type -TypeDefinition "public class HelloWorld { public static void SayHi() { System.Console.WriteLine(""Hi!""); } }"
> [HelloWorld]::SayHi()
Hi!
