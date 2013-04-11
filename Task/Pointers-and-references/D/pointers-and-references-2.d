struct S{}
class C{}

void foo(S s){} // pass by value
void foo(C c){} // pass by reference
void foo(int i){} // pass by value
void foo(int[4] i){} // pass by value
void foo(int[] i){} // pass by reference
void foo(ref T t){} // pass by reference regardless of what type T really is
