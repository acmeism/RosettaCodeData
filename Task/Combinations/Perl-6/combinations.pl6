proto combine (Int, @) {*}

multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    gather {
	take [$head, @$_] for combine($n-1, @tail);
	take [ @$_ ]      for combine($n  , @tail);
    }
}

say  combine(3, [^5]).perl;
