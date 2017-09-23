#include <iostream>

using namespace std;

template <typename T1, typename T2>
int* concatArrays( T1& array_1, T2& array_2) {
  int arrayCount_1 = sizeof(array_1) / sizeof(array_1[0]);
  int arrayCount_2 = sizeof(array_2) / sizeof(array_2[0]);
  int newArraySize = arrayCount_1 + arrayCount_2;

  int *p = new int[newArraySize];

  for (int i = 0; i < arrayCount_1; i++) {
    p[i] = array_1[i];
  }

  for (int i = arrayCount_1; i < newArraySize; i++) {
    int newIndex = i-arrayCount_2;

    if (newArraySize % 2 == 1)
	newIndex--;

    p[i] = array_2[newIndex];
    cout << "i: " << i << endl;
    cout << "array_2[i]: " << array_2[newIndex] << endl;
    cout << endl;
  }

  return p;
}

int main() {

  int ary[4] = {1, 2, 3, 123};
  int anotherAry[3] = {4, 5, 6};

  int *r = concatArrays(ary, anotherAry);

  cout << *(r + 0) << endl;
  cout << *(r + 1) << endl;
  cout << *(r + 2) << endl;
  cout << *(r + 3) << endl;
  cout << *(r + 4) << endl;
  cout << *(r + 5) << endl;
  cout << *(r + 6) << endl;

  delete r;

  return 0;
}
