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

role DLList[::DLE] {
    has DLE $.first;
    has DLE $.last;

    submethod BUILD {
	$!first = DLE.new;
	$!last = DLE.new;
	$!first.next = $!last;
	$!last.prev = $!first;
    }

    method list { ($!first.next, *.next ...^ !*.next).map: *.payload }
    method reverse { ($!last.prev, *.prev ...^ !*.prev).map: *.payload }
}

class DLElem_Str does DLElem[Str] {}
class DLList_Str does DLList[DLElem_Str] {}

my $sdll = DLList_Str.new;
my $b = $sdll.first.post-insert('A').post-insert('B');
$b.pre-insert('C');
say $sdll.list;  # A C B
