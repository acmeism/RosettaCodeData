public sealed class Singleton1 //Lazy: Yes ||| Thread-safe: Yes ||| Uses locking: Yes
{
    private static Singleton1 instance;
    private static readonly object lockObj = new object();

    public static Singleton1 Instance {
        get {
            lock(lockObj) {
                if (instance == null) {
                    instance = new Singleton1();
                }
            }
            return instance;
        }
    }
}
