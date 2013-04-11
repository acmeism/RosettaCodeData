class Singleton
{
public:
     static Singleton* Instance()
     {
          // We need to ensure that we don't accidentally create two Singletons
          HANDLE hMutex = CreateMutex(NULL, FALSE, "MySingletonMutex");
          WaitForSingleObject(hMutex, INFINITE);

          // Create the instance of the class.
          // Since it's a static variable, if the class has already been created,
          // It won't be created again.
          static Singleton myInstance;

          // Release our mutex so that other application threads can use this function
          ReleaseMutex( hMutex );

          // Free the handle
          CloseHandle( hMutex );

          // Return a pointer to our mutex instance.
          return &myInstance;
     }

     // Any other public methods

protected:
     Singleton()
     {
          // Constructor code goes here.
     }
     ~Singleton()
     {
          // Destructor code goes here.
     }

     // And any other protected methods.
}
