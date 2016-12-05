class KnapsackItem {
  has $.name;
  has $.weight is rw;
  has $.price is rw;
  has $.ppw;

  method new (Str $n, Rat $w, Int $p) {
    self.bless(:name($n), :weight($w), :price($p), :ppw($w/$p))
  }

  method cut-maybe ($max-weight) {
    return False if $max-weight > $.weight;
    $.price = $max-weight / $.ppw;
    $.weight = $.ppw * $.price;
    return True;
  }

  method gist () { sprintf "%8s %1.2f   %3.2f",
                            $.name,
                                $.weight,
                                        $.price }
}

my $max-w = 15;
say    "Item    Portion Value";

.say for gather
    for < beef    3.8 36
          pork    5.4 43
          ham     3.6 90
          greaves 2.4 45
          flitch  4.0 30
          brawn   2.5 56
          welt    3.7 67
          salami  3.0 95
          sausage 5.9 98 >
        ==> map({ KnapsackItem.new($^a, $^b, $^c) })
        ==> sort *.ppw
    {
        my $last-one = .cut-maybe($max-w);
        take $_;
        $max-w -= .weight;
        last if $last-one;
    }
