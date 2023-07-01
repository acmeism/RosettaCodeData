sub s_of_n_creator($n) {
    my (@sample, $i);
    -> $item {
        if    ++$i    <= $n { @sample.push:      $item }
        elsif $i.rand <  $n { @sample[$n.rand] = $item }
        @sample
    }
}

my @bin;
for ^100000 {
    my &s_of_n = s_of_n_creator 3;
    sink .&s_of_n for ^9;
    @bin[$_]++ for s_of_n 9;
}

say @bin;
