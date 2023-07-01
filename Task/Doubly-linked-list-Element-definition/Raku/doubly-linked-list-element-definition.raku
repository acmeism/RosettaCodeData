role DLElem[::T] {
    has DLElem[T] $.prev is rw;
    has DLElem[T] $.next is rw;
    has T $.payload = T;

    method pre-insert(T $payload) {
        die "Can't insert before beginning" unless $!prev;
        my $elem = ::?CLASS.new(:$payload);
        $!prev.next = $elem;
        $elem.prev = $!prev;
        $elem.next = self;
        $!prev = $elem;
        $elem;
    }

    method post-insert(T $payload) {
        die "Can't insert after end" unless $!next;
        my $elem = ::?CLASS.new(:$payload);
        $!next.prev = $elem;
        $elem.next = $!next;
        $elem.prev = self;
        $!next = $elem;
        $elem;
    }

    method delete {
        die "Can't delete a sentinel" unless $!prev and $!next;
        $!next.prev = $!prev;
        $!prev.next = $!next;   # conveniently returns next element
    }
}
