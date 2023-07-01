void* memory_for_p = operator new(sizeof(int));
int* p = new(memory_for_p) int(3);
