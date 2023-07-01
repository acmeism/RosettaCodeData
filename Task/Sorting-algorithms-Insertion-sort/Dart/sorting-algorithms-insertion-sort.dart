insertSort(List<int> array){
  for(int i = 1; i < array.length; i++){
    int value = array[i];
    int j = i - 1;
    while(j >= 0 && array[j] > value){
      array[j + 1] = array[j];
      j = j - 1;
    }
    array[j + 1] = value;
  }
  return array;
}

void main() {
    List<int> a = insertSort([10, 3, 11, 15, 19, 1]);
    print('${a}');
}
