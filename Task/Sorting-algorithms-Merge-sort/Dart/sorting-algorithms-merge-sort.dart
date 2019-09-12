void main() {
  MergeSortInDart sampleSort = MergeSortInDart();

  List<int> theResultingList = sampleSort.sortTheList([54, 89, 125, 47899, 32, 61, 42, 895647, 215, 345, 6, 21, 2, 78]);

  print('Here\'s the sorted list: ${theResultingList}');
}

/////////////////////////////////////

class MergeSortInDart {

  List<int> sortedList;

  // In Dart we often put helper functions at the bottom.
  // You could put them anywhere, we just like it this way
  // for organizational purposes. It's nice to be able to
  // read them in the order they're called.

  // Start here
  List<int> sortTheList(List<int> sortThis){
    // My parameters are listed vertically for readability. Dart
    // doesn't care how you list them, vertically or horizontally.
    sortedList = mSort(
      sortThis,
      sortThis.sublist(0, sortThis.length),
      sortThis.length,
    );
    return sortThis;
  }

  mSort(
    List<int> sortThisList,
    List<int> tempList,
    int thisListLength) {

    if (thisListLength == 1) {
      return;
    }

    // In Dart using ~/ is more efficient than using .floor()
    int middle = (thisListLength ~/ 2);

    // If you use something in a try/on/catch/finally block then
    // be sure to declare it outside the block (for scope)
    List<int> tempLeftList;

    // This was used for troubleshooting. It was left here to show
    // how a basic block try/on can be better than a debugPrint since
    // it won't print unless there's a problem.
    try {
      tempLeftList = tempList.sublist(0, middle);
    } on RangeError {
      print(
          'tempLeftList length = ${tempList.length}, thisListLength '
            'was supposedly $thisListLength and Middle was $middle');
    }

    // If you see "myList.getRange(x,y)" that's a sign the code is
    // from Dart 1 and needs to be updated. It's "myList.sublist" in Dart 2
    List<int> tempRightList = tempList.sublist(middle);

    // Left side.
    mSort(
      tempLeftList,
      sortThisList.sublist(0, middle),
      middle,
    );

    // Right side.
    mSort(
      tempRightList,
      sortThisList.sublist(middle),
      sortThisList.length - middle,
    );

    // Merge it.
    dartMerge(
      tempLeftList,
      tempRightList,
      sortThisList,
    );
  }

  dartMerge(
    List<int> leftSide,
    List<int> rightSide,
    List<int> sortThisList,
    ) {
    int index = 0;
    int elementValue;

    // This should be human readable.
    while (leftSide.isNotEmpty && rightSide.isNotEmpty) {
      if (rightSide[0] < leftSide[0]) {
        elementValue = rightSide[0];
        rightSide.removeRange(0, 1);
      } else {
        elementValue = leftSide[0];
        leftSide.removeRange(0, 1);
      }
      sortThisList[index++] = elementValue;
    }

    while (leftSide.isNotEmpty) {
      elementValue = leftSide[0];
      leftSide.removeRange(0, 1);
      sortThisList[index++] = elementValue;
    }

    while (rightSide.isNotEmpty) {
      elementValue = rightSide[0];
      rightSide.removeRange(0, 1);
      sortThisList[index++] = elementValue;
    }
    sortedList = sortThisList;
  }
}
