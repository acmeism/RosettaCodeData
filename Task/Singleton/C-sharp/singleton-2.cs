public sealed class Singleton2 //Lazy: Yes ||| Thread-safe: Yes ||| Uses locking: Yes, but only once
{
    private static Singleton2 instance;
    private static readonly object lockObj = new object();

    public static Singleton2 Instance {
        get {
            if (instance == null) {
                lock(lockObj) {
                    if (instance == null) {
                        instance = new Singleton2();
                    }
                }
            }
            return instance;
        }
    }
}
