int main()
{
  void* memory = operator new(20); // allocate 20 bytes of memory
  operator delete(memory);         // deallocate it
}
