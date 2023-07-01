class arena { /* ... */ };

void* operator new(std::size_t size, arena& a)
{
  return arena.alloc(size);
}

void operator delete(void* p, arena& a)
{
  arena.dealloc(p);
}

arena whatever(/* ... */);

int* p = new(whatever) int(3); // uses operator new from above to allocate from the arena whatever
