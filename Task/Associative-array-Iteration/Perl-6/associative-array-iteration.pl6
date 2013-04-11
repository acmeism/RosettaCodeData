my %pairs = hello => 13, world => 31, '!' => 71;

for %pairs.kv -> $k, $v {
    say "(k,v) = ($k, $v)";
}

{ say "$^a => $^b" } for %pairs.kv;

say "key = $_" for %pairs.keys;

say "value = $_" for %pairs.values;
