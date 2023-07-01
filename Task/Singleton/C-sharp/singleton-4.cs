public sealed class Singleton4 //Lazy: Yes ||| Thread-safe: Yes ||| Uses locking: No
{
    public static Singleton4 Instance => SingletonHolder.instance;

    private class SingletonHolder
    {
        static SingletonHolder() { }

        internal static readonly Singleton4 instance = new Singleton4();
    }
}
