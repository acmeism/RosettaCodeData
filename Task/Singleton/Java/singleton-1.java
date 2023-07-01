class Singleton
{
    private static Singleton myInstance;
    public static Singleton getInstance()
    {
        if (myInstance == null)
        {
            synchronized(Singleton.class)
            {
                if (myInstance == null)
                {
                    myInstance = new Singleton();
                }
            }
        }

        return myInstance;
    }

    protected Singleton()
    {
        // Constructor code goes here.
    }

    // Any other methods
}
