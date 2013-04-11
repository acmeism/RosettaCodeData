class Singleton
{
public:
     static Singleton* Instance()
     {
          // Since it's a static variable, if the class has already been created,
          // It won't be created again.
          static Singleton myInstance;

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
