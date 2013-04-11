class MyClass { /*...*/ };

int main()
{
  MyClass* p = new(whatever) MyClass; // allocate memory for myclass from arena and construct a MyClass object there
  // ...
  p->~MyClass(); // explicitly destruct *p
  operator delete(p, whatever); // explicitly deallocate the memory
}
