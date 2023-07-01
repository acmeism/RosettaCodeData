class invertedAssign {
  int data;
public:
  invertedAssign(int data):data(data){}
  int getData(){return data;}
  void operator=(invertedAssign& other) const {
    other.data = this->data;
  }
};


#include <iostream>

int main(){
  invertedAssign a = 0;
  invertedAssign b = 42;
  std::cout << a.getData() << ' ' << b.getData() << '\n';

  b = a;

  std::cout << a.getData() << ' ' << b.getData() << '\n';
}
