main
 new collection,size
 set size=16
 set collection=size for i=0:1:size-1 set collection(i)=$random(size)
 write "Collection to sort:",!!
 zwrite collection ; This will only work on Intersystem's flavor of MUMPS
 do quicksort(.collection,0,collection-1)
 write:$$isSorted(.collection) !,"Collection is sorted:",!!
 zwrite collection  ; This will only work on Intersystem's flavor of MUMPS
 q
quicksort(array,low,high)
 if low<high do
 . set pivot=$$partition(.array,low,high)
 . do quicksort(.array,low,pivot-1)
 . do quicksort(.array,pivot+1,high)
 q
partition(A,p,r)
 set pivot=A(r)
 set i=p-1
 for j=p:1:r-1 do
 . i A(j)<=pivot do
 . . set i=i+1
 . . set helper=A(j)
 . . set A(j)=A(i)
 . . set A(i)=helper
 set helper=A(r)
 set A(r)=A(i+1)
 set A(i+1)=helper
 quit i+1
isSorted(array)
 set sorted=1
 for i=0:1:array-2 do  quit:sorted=0
 . for j=i+1:1:array-1 do  quit:sorted=0
 . . set:array(i)>array(j) sorted=0
 quit sorted
