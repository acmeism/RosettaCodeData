#include <cstdlib>
#include <cassert>
#include <new>

// This class basically provides a global stack of pools; it is not thread-safe, and pools must be destructed in reverse order of construction
// (you definitely want something better in production use :-))
class Pool
{
public:
  Pool(std::size_type sz);
  ~Pool();
  static Pool& current() { return *cur; }
  void* allocate(std::size_type sz, std::size_t alignment);
private:
  char* memory; // char* instead of void* enables pointer arithmetic
  char* free;
  char* end;
  Pool* prev;
  static Pool* cur;

  // prohibit copying
  Pool(Pool const&); // not implemented
  Pool& operator=(Pool const&); // not implemented
};

Pool* pool::cur = 0;

Pool::Pool(std::size_type size):
  memory(static_cast<char*>(::operator new(size))),
  free(memory),
  end(memory + size))
{
  prev = cur;
  cur = this;
}

Pool::~Pool()
{
  ::operator delete(memory);
  cur = prev;
}

void* Pool::allocate(std::size_t size, std::size_t alignment)
{
  char* start = free;

  // align the pointer
  std::size_t extra = (start - memory) % aligment;
  if (extra != 0)
  {
    extra = alignment - extra;
  }

  // test if we can still allocate that much memory
  if (end - free < size + extra)
    throw std::bad_alloc();

  // the free memory now starts after the newly allocated object
  free = start + size + extra;
  return start;
}

// this is just a simple C-like struct, except that it uses a specific allocation/deallocation function.
struct X
{
  int member;
  void* operator new(std::size_t);
  void operator delete(void*) {} // don't deallocate memory for single objects
};

void* X::operator new(std::size_t size)
{
  // unfortunately C++ doesn't offer a portable way to find out alignment
  // however, using the size as alignment is always safe (although usually wasteful)
  return Pool::current().allocate(size, size);
}

// Example program
int main()
{
  Pool my_pool(3*sizeof(X));
  X* p1 = new X; // uses the allocator function defined above
  X* p2 = new X;
  X* p3 = new X;
  delete p3; // doesn't really deallocate the memory because operator delete has an empty body

  try
  {
    X* p4 = new X; // should fail
    assert(false);
  }
  catch(...)
  {
  }

  X* p5 = new X[10]; // uses global array allocation routine because we didn't provide operator new[] and operator delete[]
  delete[] p5; // global array deallocation

  Pool* my_second_pool(1000); // a large pool
  X* p6 = new X; // allocate a new object from that pool
  X* p7 = new X;
  delete my_second_pool // also deallocates the memory for p6 and p7

} // Here my_pool goes out of scope, deallocating the memory for p1, p2 and p3
