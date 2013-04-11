class Hofstadter {
  has @!c = 1,1;
  multi method postcircumfix:<[ ]> ($me: Int $i) {
    @!c.push($me[@!c.elems-$me[@!c.elems-1]] +
	     $me[@!c.elems-$me[@!c.elems-2]]) until @!c.exists($i);
    return @!c[$i];
  }

  # note that this method isn't strictly required for solving the task,
  # it's just a wrapper to get more than one item
  multi method postcircumfix:<[ ]> ($me: Range $is) {
    return gather {take $me[$_] for $is.iterator;}
  }
}
