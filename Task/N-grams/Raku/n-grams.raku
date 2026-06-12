sub n-gram ($this, $N=2) { Bag.new( flat $this.uc.map: { .comb.rotor($N => -($N-1))».join } ) }
dd 'Live and let live'.&n-gram; # bi-gram
dd 'Live and let live'.&n-gram(3); # tri-gram
