$string = "Jose\x{301}"; # "José" in NFD
$flip = join("", reverse $string =~ /\X/g); # becomes "ésoJ"
