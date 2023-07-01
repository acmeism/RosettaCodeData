class Non-Delegate  { }

class Delegate {
	method thing {
		return "delegate implementation"
	}
}

class Delegator {
	has $.delegate is rw;

	method operation {
		$.delegate.^can( 'thing' ) ?? $.delegate.thing
		!! "default implementation"
	}
}

my Delegator $d .= new;

say "empty: "~$d.operation;

$d.delegate = Non-Delegate.new;

say "Non-Delegate: "~$d.operation;

$d.delegate = Delegate.new;

say "Delegate: "~$d.operation;
