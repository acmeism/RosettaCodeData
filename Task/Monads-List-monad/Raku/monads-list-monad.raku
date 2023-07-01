multi bind (@list, &code) { @list.map: &code };

multi bind ($item, &code) { $item.&code };

sub divisors (Int $int) { gather for 1 .. $int { .take if $int %% $_ } }

put (^10).&bind(* + 3).&bind(&divisors)».&bind(*.base: 2).join: "\n";
