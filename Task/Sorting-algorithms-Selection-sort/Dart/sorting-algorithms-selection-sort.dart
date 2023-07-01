void main() {
    List<int> a = selectionSort([1100, 2, 56, 200, -52, 3, 99, 33, 177, -199]);
    print('$a');
}

selectionSort(List<int> array){
	for(int currentPlace = 0;currentPlace<array.length-1;currentPlace++){
		int smallest = 4294967296; //maxInt
		int smallestAt = currentPlace+1;
		for(int check = currentPlace; check<array.length;check++){
			if(array[check]<smallest){
				smallestAt = check;
				smallest = array[check];
			}
		}
		int temp = array[currentPlace];
		array[currentPlace] = array[smallestAt];
		array[smallestAt] = temp;
	}
  return array;
}
