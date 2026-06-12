for <1 2 3 4 5>, 6
   ,<1 1 2 3 3 4 5>, 6
   ,<1 2 3 4 5 5 5 5 15 15 10 10 10 10 25 100>, 40
  -> @items, $sum {

    put "\n\nHow many combinations of [{ @items.join: ', ' }] sum to $sum?";

    given ^@items .combinations.grep: { @items[$_].sum == $sum } {
        .&display;
        display .race.map( { Slip(.permutations) } ), '';
    }
}

sub display ($list, $un = 'un') {
    put "\nOrder {$un}important:\nCount: { +$list }\nIndices" ~ ( +$list > 10 ?? ' (10 random examples):' !! ':' );
    put $list.pick(10).sort».join(', ').join: "\n"
}
