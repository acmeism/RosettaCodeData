public sealed class Singleton5 //Lazy: Yes ||| Thread-safe: Yes ||| Uses locking: No
{
    private static readonly Lazy<Singleton5> lazy = new Lazy<Singleton5>(() => new Singleton5());

    public static Singleton5 Instance => lazy.Value;
}
