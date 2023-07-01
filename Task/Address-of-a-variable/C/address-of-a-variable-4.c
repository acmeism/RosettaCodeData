#include <new>
struct S { int i = 0; S() {} };
auto& s = *new (reinterpret_cast<void*>(0xa100)) S;
