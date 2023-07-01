def siftDown(a, start, end):
   // (end represents the limit of how far down the heap to sift)
   var root = start

   while root * 2 + 1 <= end:           // (While the root has at least one child)
      var child = root * 2 + 1          // (root*2+1 points to the left child)
      // (If the child has a sibling and the child's value is less than its sibling's...)
      if child + 1 <= end and a[child] < a[child + 1]:
         child += 1                     // (... then point to the right child instead)
      if a[root] < a[child]:            // (out of max-heap order)
         let r = a[root]                // swap(a[root], a[child])
         a[root] = a[child]
         a[child] = r
         root = child                   // (repeat to continue sifting down the child now)
      else:
         return

def heapify(a, count):
   //(start is assigned the index in a of the last parent node)
   var start = (count - 2) >> 1

   while start >= 0:
      // (sift down the node at index start to the proper place
      //  such that all nodes below the start index are in heap order)
      siftDown(a, start, count-1)
      start -= 1
   // (after sifting down the root all nodes/elements are in heap order)

def heapSort(a):
   // input: an unordered array a of length count
   let count = a.length
   // (first place a in max-heap order)
   heapify(a, count)

   var end = count - 1
   while end > 0:
      //(swap the root(maximum value) of the heap with the last element of the heap)
      let z = a[0]
      a[0] = a[end]
      a[end] = z
      //(decrement the size of the heap so that the previous max value will stay in its proper place)
      end -= 1
      // (put the heap back in max-heap order)
      siftDown(a, 0, end)

let inputi = [1,10,2,5,-1,5,-19,4,23,0]
print ("input:  " + inputi)
heapSort(inputi)
print ("sorted: " + inputi)
let inputf = [1,-3.2,5.2,10.8,-5.7,7.3,3.5,0,-4.1,-9.5]
print ("input:  " + inputf)
heapSort(inputf)
print ("sorted: " + inputf)
let inputs = ["We","hold","these","truths","to","be","self-evident","that","all","men","are","created","equal"]
print ("input:  " + inputs)
heapSort(inputs)
print ("sorted: " + inputs)
