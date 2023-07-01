class MyClass
{
public:
  void someMethod(); // member function = method
  MyClass(); // constructor
private:
  int variable; // member variable = instance variable
};

// implementation of constructor
MyClass::MyClass():
  variable(0)
{
  // here could be more code
}

// implementation of member function
void MyClass::someMethod()
{
  variable = 1; // alternatively: this->variable = 1
}

// Create an instance as variable
MyClass instance;

// Create an instance on free store
MyClass* pInstance = new MyClass;
// Instances allocated with new must be explicitly destroyed when not needed any more:
delete pInstance;
