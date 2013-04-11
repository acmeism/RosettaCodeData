role Filter[Int $factor] {
    method next { repeat until $.value % $factor { callsame } }
}

class Stream {
    has Int $.value is rw = 1;

    method next { ++$.value }
    method filter { self but Filter[$.value] }
}

.next, say .value for Stream.new, *.filter ... *;
