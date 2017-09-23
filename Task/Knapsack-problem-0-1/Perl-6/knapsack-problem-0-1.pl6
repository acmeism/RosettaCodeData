my class KnapsackItem { has $.name; has $.weight; has $.unit; }

multi sub pokem ([],           $,  $v = 0) { $v }
multi sub pokem ([$,  *@],     0,  $v = 0) { $v }
multi sub pokem ([$i, *@rest], $w, $v = 0) {
  my $key = "{+@rest} $w $v";
  (state %cache){$key} or do {
    my @skip = pokem @rest, $w, $v;
    if $w >= $i.weight { # next one fits
      my @put = pokem @rest, $w - $i.weight, $v + $i.unit;
      return (%cache{$key} = |@put, $i.name).list if @put[0] > @skip[0];
    }
    return (%cache{$key} = |@skip).list;
  }
}

my $MAX_WEIGHT = 400;
my @table = flat map -> $name,  $weight,  $unit {
     KnapsackItem.new: :$name, :$weight, :$unit;
},
    'map',                      9, 150,
    'compass',                 13,  35,
    'water',                  153, 200,
    'sandwich',                50, 160,
    'glucose',                 15,  60,
    'tin',                     68,  45,
    'banana',                  27,  60,
    'apple',                   39,  40,
    'cheese',                  23,  30,
    'beer',                    52,  10,
    'suntan cream',            11,  70,
    'camera',                  32,  30,
    'T-shirt',                 24,  15,
    'trousers',                48,  10,
    'umbrella',                73,  40,
    'waterproof trousers',     42,  70,
    'waterproof overclothes',  43,  75,
    'note-case',               22,  80,
    'sunglasses',               7,  20,
    'towel',                   18,  12,
    'socks',                    4,  50,
    'book',                    30,  10;

my ($value, @result) = pokem @table, $MAX_WEIGHT;
say "Value = $value\nTourist put in the bag:\n  " ~ @result;
