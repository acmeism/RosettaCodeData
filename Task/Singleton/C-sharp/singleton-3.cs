public sealed class Singleton3 //Lazy: Yes, but not completely ||| Thread-safe: Yes ||| Uses locking: No
{
    private static Singleton3 Instance { get; } = new Singleton3();

    static Singleton3() { }
}
