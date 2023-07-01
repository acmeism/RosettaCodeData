class Singleton
{
    private static Singleton myInstance;
    public static Singleton getInstance()
    {
        if (myInstance == null)
        {
            myInstance = new Singleton();
        }

        return myInstance;
    }

    protected Singleton()
    {
        // Constructor code goes here.
    }

    // Any other methods
}
