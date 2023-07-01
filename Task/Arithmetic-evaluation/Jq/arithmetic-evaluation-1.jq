def star(E): (E | star(E)) // .;
def plus(E): E | (plus(E) // . );
def optional(E): E // .;
def amp(E): . as $in | E | $in;
def neg(E): select( [E] == [] );
