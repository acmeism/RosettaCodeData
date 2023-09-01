def makeSwap (list, element1, element2) {
    //exchanges two elements in a list.
    //print a dot for each swap.
    print "."
    list[[element2,element1]] = list[[element1,element2]]
}

def checkSwap (list, child, parent) {
    //check if parent is smaller than child, then swap.
    if (list[parent] < list[child]) makeSwap(list, child, parent)
}

def siftDown (list, start, end) {
    //end represents the limit of how far down the heap to sift
    //start is the head of the heap
    def parent = start
    while (parent*2 < end) { //While the root has at least one child
        def child = parent*2 + 1 //root*2+1 points to the left child
        //find the child with the higher value
        //if the child has a sibling and the child's value is less than its sibling's..
        if (child + 1 <= end && list[child] < list[child+1]) child++  //point to the other child
        if (checkSwap(list, child, parent)) {  //check if parent is smaller than child and swap
            parent = child                  //make child to next parent
        } else {
            return                          //The rest of the heap is in order - return.
        }
    }
}

def heapify (list) {
    // Create a heap out of a list
    // run through all the heap parents and
    // ensure that each parent is lager than the child for all parent/childs.
    // (list.size() -2) / 2 = last parent in the heap.
    for (start in ((list.size()-2).intdiv(2))..0 ) {
        siftDown(list, start, list.size() - 1)
    }
}

def heapSort (list) {
    //heap sort any unsorted list
    heapify(list)  //ensure that the list is in a binary heap state
    //Run the list backwards and
    //for end = (size of list -1 ) to 0
    for (end in (list.size()-1)..0 ) {
        makeSwap(list, 0, end)    //put the top of the heap to the end (largest element)
        siftDown(list, 0, end-1)    //ensure that the rest is a heap again
    }
    list
}
