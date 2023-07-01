    my @fields = $string =~ /\G (?:^ | $sep) \K (?: [^$sep$esc] | $esc .)*/gsx;
