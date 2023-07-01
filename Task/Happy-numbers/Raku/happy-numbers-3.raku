subset Happy of Int where sub ($n) {
    $n == 1 ?? True  !!
    $n < 7  ?? False !!
    &?ROUTINE([+] $n.comb »**» 2);
}

say (grep Happy, 1 .. *)[^8];
