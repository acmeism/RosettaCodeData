#include <cstddef>
#include <cstdlib>
#include <new>

class MyClass
{
public:
  void* operator new(std::size_t size)
  {
    void* p = std::malloc(size);
    if (!p) throw std::bad_alloc();
    return p;
  }
  void operator delete(void* p)
  {
    free(p);
  }
};

int main()
{
  MyClass* p = new MyClass; // uses class specific operator new
  delete p;                 // uses class specific operator delete

  int* p2 = new int; // uses default operator new
  delete p2;         // uses default operator delete
}
