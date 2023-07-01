sub r2cf(Rat $x is copy) { gather $x [R/]= 1 while ($x -= take $x.floor) > 0 }
