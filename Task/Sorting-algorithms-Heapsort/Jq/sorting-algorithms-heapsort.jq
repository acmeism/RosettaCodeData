def swap($a; $i; $j):
  $a
  | .[$i] as $t
  | .[$i] = .[$j]
  | .[$j] = $t ;

def siftDown($a; $start; $iend):
  { $a, root: $start }
  | until( .stop or (.root*2 + 1 > $iend);
      .child = .root*2 + 1
      | if .child + 1 <= $iend and .a[.child] < .a[.child+1]
        then .child += 1
	else .
	end
        | if .a[.root] < .a[.child]
          then
	  .a = swap(.a; .root; .child)
          | .root = .child
          else .stop = true
          end)
  | .a ;

def heapify:
  length as $count
  | {a: ., start: ((($count - 2)/2)|floor)}
  | until(.start < 0;
        .a = siftDown(.a; .start; $count - 1)
        | .start += -1 )
  | .a ;

def heapSort:
  { a: heapify,
    iend: (length - 1) }
  | until( .iend <= 0;
        .a = swap(.a; 0; .iend)
        | .iend += -1
        | .a = siftDown(.a; 0; .iend) )
  | .a ;

[4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3]
|
 "Before: \(.)",
 "After : \(heapSort)\n"
